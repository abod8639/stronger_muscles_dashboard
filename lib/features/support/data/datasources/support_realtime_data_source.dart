import 'dart:async';
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
          refresh();
        },
      );

      _channel = _pusherClient!.publicChannel(channelName);

      // 1. Listen for new ticket creation
      final subCreate = _channel!.bind('SupportTicketCreated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] is Map) {
          final ticketMap = Map<String, dynamic>.from(map['ticket'] as Map);
          _ticketCreatedController.add(SupportTicketModel.fromJson(ticketMap));
        }
      });

      // 2. Listen for ticket status/priority/assignment updates
      final subUpdate = _channel!.bind('SupportTicketUpdated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] is Map) {
          final ticketMap = Map<String, dynamic>.from(map['ticket'] as Map);
          _ticketUpdatedController.add(SupportTicketModel.fromJson(ticketMap));
        }
      });

      // 3. Listen for incoming messages
      final subMessage = _channel!.bind('SupportMessageSent').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['message'] is Map) {
          final ticketId = map['ticket_id'] is int
              ? map['ticket_id'] as int
              : int.tryParse(map['ticket_id']?.toString() ?? '0') ?? 0;
          final msgMap = Map<String, dynamic>.from(map['message'] as Map);
          _messageSentController.add((
            ticketId,
            SupportMessageModel.fromJson(msgMap),
          ));
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
