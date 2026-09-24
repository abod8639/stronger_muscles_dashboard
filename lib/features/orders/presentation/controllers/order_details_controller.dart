import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/services/invoice_pdf_service.dart';

class OrderDetailsController extends GetxController {
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final OrdersController? _ordersController;

  final Rx<OrderEntity> order;
  final RxBool isUpdatingStatus = false.obs;
  final RxBool isGeneratingPdf = false.obs;

  OrderDetailsController({
    required OrderEntity initialOrder,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    OrdersController? ordersController,
  })  : order = Rx<OrderEntity>(initialOrder),
        _updateOrderStatusUseCase = updateOrderStatusUseCase,
        _ordersController = ordersController;

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

  /// تحديث حالة الطلب ومزامنتها مع الـ OrdersController والواجهة
  Future<void> updateOrderStatus(OrderStatus newStatus) async {
    if (isUpdatingStatus.value) return;

    try {
      isUpdatingStatus.value = true;
      final updatedOrder = await _updateOrderStatusUseCase(order.value.id, newStatus);
      order.value = updatedOrder;

      // مزامنة التحديث مع قائمة الطلبات الرئيسية إن وجدت في الذاكرة
      if (_ordersController != null) {
        final index = _ordersController.paginatedOrders.indexWhere((o) => o.id == updatedOrder.id);
        if (index != -1) {
          // تحديث السجلات في controller
          _ordersController.fetchOrders();
        }
      }

      Get.snackbar(
        'تم التحديث',
        'تم تغيير حالة الطلب إلى "${getStatusText(newStatus)}" بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'فشل التحديث',
        'تعذر تحديث حالة الطلب: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.85),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  /// طباعة الفاتورة أو حفظها كـ PDF
  Future<void> printInvoice() async {
    if (isGeneratingPdf.value) return;

    try {
      isGeneratingPdf.value = true;
      await InvoicePdfService.printInvoice(order.value);
    } catch (e) {
      Get.snackbar(
        'خطأ في الطباعة',
        'تعذر إنشاء الفاتورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.85),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  /// مشاركة ملف الفاتورة PDF
  Future<void> shareInvoice() async {
    if (isGeneratingPdf.value) return;

    try {
      isGeneratingPdf.value = true;
      await InvoicePdfService.shareInvoice(order.value);
    } catch (e) {
      Get.snackbar(
        'خطأ في المشاركة',
        'تعذر مشاركة ملف الفاتورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.85),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  /// نسخ رقم الطلب إلى الحافظة
  void copyOrderId() {
    Clipboard.setData(ClipboardData(text: order.value.id));
    Get.snackbar(
      'تم النسخ',
      'تم نسخ رقم الطلب إلى الحافظة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// الاتصال بالعميل
  Future<void> callCustomer(String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('تعذر الاتصال', 'لا يمكن فتح تطبيق الهاتف على هذا الجهاز');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في محاولة إجراء المكالمة');
    }
  }

  /// إرسال بريد إلكتروني للعميل
  Future<void> emailCustomer(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('تعذر الإرسال', 'لا يمكن فتح تطبيق البريد على هذا الجهاز');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في محاولة فتح تطبيق البريد');
    }
  }

  /// فتح العنوان في خرائط Google
  Future<void> openGoogleMaps(AddressEntity address) async {
    final String query = address.hasCoordinates
        ? '${address.latitude},${address.longitude}'
        : address.fullAddress;

    if (query.trim().isEmpty) {
      Get.snackbar('تنبيه', 'عنوان الشحن غير متوفر');
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
      Get.snackbar('خطأ', 'تعذر فتح خرائط Google: $e');
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
