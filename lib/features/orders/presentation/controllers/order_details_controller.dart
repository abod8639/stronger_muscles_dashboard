import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/services/invoice_pdf_service.dart';

/// متحكم تفاصيل وإجراءات الطلب كـ [ChangeNotifier] نقي
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

  /// تأكيد الطلب بنقله إلى حالة "قيد المعالجة"
  Future<void> confirmOrder() async {
    await updateOrderStatus(OrderStatus.processing);
  }

  /// شحن الطلب بنقله إلى حالة "تم الشحن"
  Future<void> shipOrder() async {
    await updateOrderStatus(OrderStatus.shipped);
  }

  /// توصيل الطلب بنقله إلى حالة "تم التوصيل"
  Future<void> deliverOrder() async {
    await updateOrderStatus(OrderStatus.delivered);
  }

  /// إلغاء الطلب بنقله إلى حالة "ملغي"
  Future<void> cancelOrder() async {
    await updateOrderStatus(OrderStatus.cancelled);
  }

  /// تحديث حالة الطلب ومزامنتها مع الواجهة
  Future<void> updateOrderStatus(OrderStatus newStatus) async {
    if (_isUpdatingStatus) return;

    try {
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
    } catch (e) {
      AppFeedback.showError('تعذر تحديث حالة الطلب: $e');
    } finally {
      _isUpdatingStatus = false;
      notifyListeners();
    }
  }

  /// طباعة الفاتورة أو حفظها كـ PDF
  Future<void> printInvoice() async {
    if (_isGeneratingPdf) return;

    try {
      _isGeneratingPdf = true;
      notifyListeners();
      await InvoicePdfService.printInvoice(order);
    } catch (e) {
      AppFeedback.showError('تعذر إنشاء الفاتورة: $e');
    } finally {
      _isGeneratingPdf = false;
      notifyListeners();
    }
  }

  /// مشاركة ملف الفاتورة PDF
  Future<void> shareInvoice() async {
    if (_isGeneratingPdf) return;

    try {
      _isGeneratingPdf = true;
      notifyListeners();
      await InvoicePdfService.shareInvoice(order);
    } catch (e) {
      AppFeedback.showError('تعذر مشاركة ملف الفاتورة: $e');
    } finally {
      _isGeneratingPdf = false;
      notifyListeners();
    }
  }

  /// نسخ رقم الطلب إلى الحافظة
  void copyOrderId() {
    Clipboard.setData(ClipboardData(text: order.id));
    AppFeedback.showSuccess('تم نسخ رقم الطلب إلى الحافظة');
  }

  /// الاتصال بالعميل
  Future<void> callCustomer(String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        AppFeedback.showWarning('لا يمكن فتح تطبيق الهاتف على هذا الجهاز');
      }
    } catch (e) {
      AppFeedback.showError('فشل في محاولة إجراء المكالمة');
    }
  }

  /// إرسال بريد إلكتروني للعميل
  Future<void> emailCustomer(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        AppFeedback.showWarning('لا يمكن فتح تطبيق البريد على هذا الجهاز');
      }
    } catch (e) {
      AppFeedback.showError('فشل في محاولة فتح تطبيق البريد');
    }
  }

  /// فتح العنوان في خرائط Google
  Future<void> openGoogleMaps(AddressEntity address) async {
    final String query = address.hasCoordinates
        ? '${address.latitude},${address.longitude}'
        : address.fullAddress;

    if (query.trim().isEmpty) {
      AppFeedback.showWarning('عنوان الشحن غير متوفر');
      return;
    }

    final Uri mapUri = Uri.https(
      'www.google.com',
      '/maps/search/',
      {'api': '1', 'query': query},
    );

    try {
      final launched = await launchUrl(
        mapUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(mapUri);
      }
    } catch (e) {
      AppFeedback.showError('تعذر فتح خرائط Google: $e');
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
}
