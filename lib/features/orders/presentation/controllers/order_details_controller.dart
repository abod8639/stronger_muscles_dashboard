import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/services/invoice_pdf_service.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_status_ui.dart';

/// Pure Controller managing order details actions and PDF generation.
/// Free of raw try-catch blocks in adherence to Clean Architecture.
class OrderDetailsController extends ChangeNotifier {
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final VoidCallback? _onStatusUpdated;

  /// يقرأ عملة المتجر لحظة الطباعة حتى لا يُعاد إنشاء المتحكم عند تغيّرها
  final String Function() _currency;

  OrderEntity order;
  bool _isUpdatingStatus = false;
  bool get isUpdatingStatus => _isUpdatingStatus;

  bool _isGeneratingPdf = false;
  bool get isGeneratingPdf => _isGeneratingPdf;

  OrderDetailsController({
    required OrderEntity initialOrder,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    VoidCallback? onStatusUpdated,
    required String Function() currency,
  }) : order = initialOrder,
       _currency = currency,
       _updateOrderStatusUseCase = updateOrderStatusUseCase,
       _onStatusUpdated = onStatusUpdated;

  /// Confirms order moving it to 'processing'
  Future<void> confirmOrder() async {
    await updateOrderStatus(OrderStatus.processing);
  }

  /// Ships order moving it to 'shipped'
  Future<void> shipOrder() async {
    await updateOrderStatus(OrderStatus.shipped);
  }

  /// Delivers order moving it to 'delivered'
  Future<void> deliverOrder() async {
    await updateOrderStatus(OrderStatus.delivered);
  }

  /// Cancels order moving it to 'cancelled'
  Future<void> cancelOrder() async {
    await updateOrderStatus(OrderStatus.cancelled);
  }

  /// Updates order status with functional error handling
  Future<void> updateOrderStatus(OrderStatus newStatus) async {
    if (_isUpdatingStatus) return;

    _isUpdatingStatus = true;
    notifyListeners();

    final result = await _updateOrderStatusUseCase(order.id, newStatus);

    result.fold(
      (failure) {
        debugPrint('❌ Failed to update order status: ${failure.toMessage()}');
        AppFeedback.showError(failure.toMessage());
      },
      (updatedOrder) {
        order = updatedOrder;
        notifyListeners();
        _onStatusUpdated?.call();
        AppFeedback.showSuccess(
          'تم تغيير حالة الطلب إلى "${newStatus.label}" بنجاح',
        );
      },
    );

    _isUpdatingStatus = false;
    notifyListeners();
  }

  /// Prints or saves order invoice as PDF
  Future<void> printInvoice() async {
    if (_isGeneratingPdf) return;

    _isGeneratingPdf = true;
    notifyListeners();
    await InvoicePdfService.printInvoice(order, currency: _currency());
    _isGeneratingPdf = false;
    notifyListeners();
  }

  /// Shares order invoice PDF
  Future<void> shareInvoice() async {
    if (_isGeneratingPdf) return;

    _isGeneratingPdf = true;
    notifyListeners();
    await InvoicePdfService.shareInvoice(order, currency: _currency());
    _isGeneratingPdf = false;
    notifyListeners();
  }

  /// Copies order ID to clipboard with feedback
  void copyOrderId() {
    Clipboard.setData(ClipboardData(text: order.id));
    AppFeedback.showSuccess('تم نسخ رقم الطلب بنجاح');
  }

  /// Copies text to clipboard with feedback
  void copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    AppFeedback.showSuccess('تم نسخ $label بنجاح');
  }

  /// Launches phone dialer
  Future<void> callCustomer(String? phone) async {
    if (phone == null || phone.isEmpty) {
      debugPrint('❌ Phone number is null or empty');
      AppFeedback.showError('رقم الهاتف غير متوفر');
      return;
    }
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('❌ Failed to launch phone dialer');
      
      AppFeedback.showError('تعذر فتح تطبيق الهاتف');
    }
  }

  /// Sends email to customer
  Future<void> emailCustomer(String? email) async {
    if (email == null || email.isEmpty) {
      debugPrint('❌ Email is null or empty');
      AppFeedback.showError('البريد الإلكتروني غير متوفر');
      return;
    }
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppFeedback.showError('تعذر فتح تطبيق البريد');
    }
  }

  /// Resolves the best coordinate pair (lat, lng) from address, street, or notes
  (double, double)? resolveCoordinates(AddressEntity? address) {
    final targetAddress = address ?? order.shippingAddress;
    if (targetAddress != null && targetAddress.hasCoordinates) {
      return (targetAddress.latitude!, targetAddress.longitude!);
    }

    // Try extracting coordinates from address street
    if (targetAddress?.street.isNotEmpty == true) {
      final coords = _extractCoordsFromText(targetAddress!.street);
      if (coords != null) return coords;
    }

    // Try extracting coordinates from order notes
    if (order.notes?.isNotEmpty == true) {
      final coords = _extractCoordsFromText(order.notes!);
      if (coords != null) return coords;
    }

    return null;
  }

  (double, double)? _extractCoordsFromText(String text) {
    final gmapsMatch = RegExp(r'@(-?\d{1,2}\.\d+),(-?\d{1,3}\.\d+)').firstMatch(text);
    if (gmapsMatch != null) {
      final lat = double.tryParse(gmapsMatch.group(1)!);
      final lng = double.tryParse(gmapsMatch.group(2)!);
      if (lat != null && lng != null) return (lat, lng);
    }

    final qMatch = RegExp(r'[?&](?:q|query)=(-?\d{1,2}\.\d+),(-?\d{1,3}\.\d+)').firstMatch(text);
    if (qMatch != null) {
      final lat = double.tryParse(qMatch.group(1)!);
      final lng = double.tryParse(qMatch.group(2)!);
      if (lat != null && lng != null) return (lat, lng);
    }

    final coordMatch = RegExp(r'(-?\d{1,2}\.\d{3,})[,\s]+(-?\d{1,3}\.\d{3,})').firstMatch(text);
    if (coordMatch != null) {
      final lat = double.tryParse(coordMatch.group(1)!);
      final lng = double.tryParse(coordMatch.group(2)!);
      if (lat != null && lng != null) return (lat, lng);
    }

    return null;
  }

  /// Opens Google Maps location for shipping address
  Future<void> openGoogleMaps(AddressEntity? address) async {
    await openMapLocation(address);
  }

  /// Opens map location for shipping address
  Future<void> openMapLocation(AddressEntity? address) async {
    final targetAddress = address ?? order.shippingAddress;
    final coords = resolveCoordinates(targetAddress);

    final Uri uri;
    if (coords != null) {
      uri = Uri.parse('https://www.google.com/maps?q=${coords.$1},${coords.$2}');
    } else if (targetAddress != null && targetAddress.fullAddress.isNotEmpty) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(targetAddress.fullAddress)}',
      );
    } else {
      AppFeedback.showError('بيانات الموقع غير متوفرة');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final fallback = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        if (!fallback) {
          AppFeedback.showError('تعذر فتح تطبيق الخرائط');
        }
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {
        AppFeedback.showError('تعذر فتح تطبيق الخرائط');
      }
    }
  }
}
