import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/services/invoice_pdf_service.dart';

/// Pure Controller managing order details actions and PDF generation.
/// Free of raw try-catch blocks in adherence to Clean Architecture.
class OrderDetailsController extends ChangeNotifier {
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final VoidCallback? _onStatusUpdated;

  OrderEntity order;
  bool _isUpdatingStatus = false;
  bool get isUpdatingStatus => _isUpdatingStatus;

  bool _isGeneratingPdf = false;
  bool get isGeneratingPdf => _isGeneratingPdf;

  OrderDetailsController({
    required OrderEntity initialOrder,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    VoidCallback? onStatusUpdated,
  })  : order = initialOrder,
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
        AppFeedback.showError(failure.toMessage());
      },
      (updatedOrder) {
        order = updatedOrder;
        notifyListeners();
        _onStatusUpdated?.call();
        AppFeedback.showSuccess(
          'تم تغيير حالة الطلب إلى "${getStatusText(newStatus)}" بنجاح',
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
    await InvoicePdfService.printInvoice(order);
    _isGeneratingPdf = false;
    notifyListeners();
  }

  /// Shares order invoice PDF
  Future<void> shareInvoice() async {
    if (_isGeneratingPdf) return;

    _isGeneratingPdf = true;
    notifyListeners();
    await InvoicePdfService.shareInvoice(order);
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
      AppFeedback.showError('رقم الهاتف غير متوفر');
      return;
    }
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppFeedback.showError('تعذر فتح تطبيق الهاتف');
    }
  }

  /// Sends email to customer
  Future<void> emailCustomer(String? email) async {
    if (email == null || email.isEmpty) {
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

  /// Opens Google Maps location for shipping address
  Future<void> openGoogleMaps(AddressEntity? address) async {
    await openMapLocation(address);
  }

  /// Opens map location for shipping address
  Future<void> openMapLocation(AddressEntity? address) async {
    if (address == null) return;

    final String query;
    if (address.hasCoordinates) {
      query = '${address.latitude},${address.longitude}';
    } else {
      query = Uri.encodeComponent(address.fullAddress);
    }

    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppFeedback.showError('تعذر فتح تطبيق الخرائط');
    }
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  String getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'معلق';
      case PaymentStatus.paid:
        return 'مدفوع';
      case PaymentStatus.failed:
        return 'فشل الدفع';
      case PaymentStatus.refunded:
        return 'مسترجع';
    }
  }
}
