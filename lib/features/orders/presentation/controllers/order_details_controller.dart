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

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppFeedback.showError('تعذر فتح تطبيق الخرائط');
    }
  }
}
