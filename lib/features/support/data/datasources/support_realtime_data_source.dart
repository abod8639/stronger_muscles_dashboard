import 'dart:async';
import 'dart:convert';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/foundation.dart';
import '../models/support_message_model.dart';
import '../models/support_ticket_model.dart';

abstract class SupportRealtimeDataSource {
  Stream<SupportTicketModel> get onTicketCreated;
  Stream<SupportTicketModel> get onTicketUpdated;
  Stream<(int ticketId, SupportMessageModel message)> get onMessageSent;
  void disconnect();
}

/// Pusher WebSockets implementation of [SupportRealtimeDataSource].
/// Constructor-injected configuration to ensure 100% testability without static dependencies.
class SupportRealtimeDataSourceImpl implements SupportRealtimeDataSource {
  final String host;
  final int port;
  final String key;
  final String channelName;

  final StreamController<SupportTicketModel> _ticketCreatedController =
      StreamController<SupportTicketModel>.broadcast();
  final StreamController<SupportTicketModel> _ticketUpdatedController =
      StreamController<SupportTicketModel>.broadcast();
  final StreamController<(int, SupportMessageModel)> _messageSentController =
      StreamController<(int, SupportMessageModel)>.broadcast();

  PusherChannelsClient? _pusherClient;
  PublicChannel? _channel;
  final List<StreamSubscription> _subscriptions = [];

  SupportRealtimeDataSourceImpl({
    required this.host,
    this.port = 8085,
    this.key = 'r5srrlrufruxbdrppf6x',
    this.channelName = 'support.tickets',
  }) {
    _initWebSockets();
  }

  void _initWebSockets() {
    try {
      final options = PusherChannelsOptions.fromHost(
        scheme: 'ws',
        host: host,
        port: port,
        key: key,
      );

      _pusherClient = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (exception, trace, refresh) async {
          await Future.delayed(const Duration(seconds: 5));
          refresh();
        },
      );

      _channel = _pusherClient!.publicChannel(channelName);

      // 1. Listen for new ticket creation
      final subCreate = _channel!.bind('SupportTicketCreated').listen((event) {
        try {
          final map = _extractMap(event.tryGetDataAsMap()) ?? _extractMap(event.data);
          if (map != null) {
            final ticketMap = _extractMap(map['ticket']) ?? map;
            if (ticketMap.containsKey('id')) {
              _ticketCreatedController.add(SupportTicketModel.fromJson(ticketMap));
            }
          }
        } catch (e, stack) {
          debugPrint('[SupportRealtimeDataSource] Error processing SupportTicketCreated: $e\n$stack');
        }
      });

      // 2. Listen for ticket status/priority/assignment updates
      final subUpdate = _channel!.bind('SupportTicketUpdated').listen((event) {
        try {
          final map = _extractMap(event.tryGetDataAsMap()) ?? _extractMap(event.data);
          if (map != null) {
            final ticketMap = _extractMap(map['ticket']) ?? map;
            if (ticketMap.containsKey('id')) {
              _ticketUpdatedController.add(SupportTicketModel.fromJson(ticketMap));
            }
          }
        } catch (e, stack) {
          debugPrint('[SupportRealtimeDataSource] Error processing SupportTicketUpdated: $e\n$stack');
        }
      });

      // 3. Listen for incoming messages
      final subMessage = _channel!.bind('SupportMessageSent').listen((event) {
        try {
          final map = _extractMap(event.tryGetDataAsMap()) ?? _extractMap(event.data);
          if (map == null) return;

          int ticketId = 0;
          if (map['ticket_id'] != null) {
            ticketId = int.tryParse(map['ticket_id'].toString()) ?? 0;
          }

          Map<String, dynamic>? messageMap;
          if (map.containsKey('message') && (map['message'] is Map || map['message'] is String)) {
            messageMap = _extractMap(map['message']);
          } else if (map.containsKey('id') && map.containsKey('message')) {
            // The root object is the message itself
            messageMap = map;
          }

          if (messageMap != null) {
            if (ticketId == 0 && messageMap['ticket_id'] != null) {
              ticketId = int.tryParse(messageMap['ticket_id'].toString()) ?? 0;
            }
            final messageModel = SupportMessageModel.fromJson(messageMap);
            _messageSentController.add((ticketId, messageModel));
          }
        } catch (e, stack) {
          debugPrint('[SupportRealtimeDataSource] Error processing SupportMessageSent: $e\n$stack');
        }
      });

      _subscriptions.addAll([subCreate, subUpdate, subMessage]);
      _subscriptions.add(
        _pusherClient!.onConnectionEstablished.listen((_) {
          _channel?.subscribeIfNotUnsubscribed();
        }),
      );

      _pusherClient!.connect();
    } catch (e) {
      debugPrint('[SupportRealtimeDataSource] WebSocket init error: $e');
    }
  }

  @override
  Stream<SupportTicketModel> get onTicketCreated =>
      _ticketCreatedController.stream;

  @override
  Stream<SupportTicketModel> get onTicketUpdated =>
      _ticketUpdatedController.stream;

  @override
  Stream<(int ticketId, SupportMessageModel message)> get onMessageSent =>
      _messageSentController.stream;

  /// Resilient helper to convert raw payload (Map or JSON string) into a pure Dart `Map<String, dynamic>`.
  Map<String, dynamic>? _extractMap(dynamic rawData) {
    if (rawData == null) return null;
    if (rawData is Map) {
      return Map<String, dynamic>.from(
        rawData.map((k, v) => MapEntry(k.toString(), v)),
      );
    }
    if (rawData is String && rawData.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawData);
        if (decoded is Map) {
          return Map<String, dynamic>.from(
            decoded.map((k, v) => MapEntry(k.toString(), v)),
          );
        }
      } catch (e) {
        debugPrint('[SupportRealtimeDataSource] JSON decode error: $e');
      }
    }
    return null;
  }

  @override
  void disconnect() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _channel?.unsubscribe();
    _pusherClient?.disconnect();
    _ticketCreatedController.close();
    _ticketUpdatedController.close();
    _messageSentController.close();
  }
}
