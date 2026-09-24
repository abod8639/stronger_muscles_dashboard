import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_detail_row.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_order_item.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_section.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_summary_row.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/services/invoice_pdf_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final Rx<OrderEntity> _order;
  bool _isUpdating = false;
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _order = Rx<OrderEntity>(widget.order);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 960;
    final isMobile = context.isMobile;

    return Obx(() {
      final currentOrder = _order.value;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: BaseAppBar(
          title: 'تفاصيل الطلب #${currentOrder.id}',
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon: _isGeneratingPdf
          //         ? const SizedBox(
          //             width: 18,
          //             height: 18,
          //             child: CircularProgressIndicator(strokeWidth: 2),
          //           )
          //         : const Icon(Icons.print_outlined),
          //     tooltip: 'طباعة الفاتورة',
          //     onPressed: _isGeneratingPdf ? null : _handlePrintInvoice,
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 28.0 : (isMobile ? 12.0 : 18.0),
            vertical: isMobile ? 12.0 : 18.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Header & Quick Stats
                  _buildHeroHeader(context, currentOrder),
                  const SizedBox(height: 12),

                  // 2. Order Actions Bar (تأكيد، طباعة/PDF، إلغاء)
                  _buildOrderActionsBar(context, currentOrder),
                  const SizedBox(height: 16),

                  // 3. Rearranged Content Grid
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Column (Flex 3): Products & Notes
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildProductsSection(context, currentOrder, isDark),
                              if (currentOrder.notes != null &&
                                  currentOrder.notes!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                _buildNotesSection(context, currentOrder),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Sidebar Column (Flex 2): Financial Summary, Customer Info, Shipping
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildSummarySection(context, currentOrder),
                              const SizedBox(height: 16),
                              _buildCustomerSection(context, currentOrder),
                              const SizedBox(height: 16),
                              _buildShippingAddressSection(context, currentOrder),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    // Mobile Layout: Summary first for quick financial overview, then products, customer, shipping
                    Column(
                      children: [
                        _buildSummarySection(context, currentOrder),
                        const SizedBox(height: 16),
                        _buildProductsSection(context, currentOrder, isDark),
                        const SizedBox(height: 16),
                        _buildCustomerSection(context, currentOrder),
                        const SizedBox(height: 16),
                        _buildShippingAddressSection(context, currentOrder),
                        if (currentOrder.notes != null &&
                            currentOrder.notes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildNotesSection(context, currentOrder),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ── Order Actions Bar (تأكيد، طباعة، إلغاء) ─────────────────────────────
  Widget _buildOrderActionsBar(BuildContext context, OrderEntity currentOrder) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStatus = currentOrder.status;

    final isPending = currentStatus == OrderStatus.pending;
    final canCancel = currentStatus != OrderStatus.cancelled &&
        currentStatus != OrderStatus.delivered;

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'إجراءات سريعة:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // زر طباعة الفاتورة / PDF
                FilledButton.tonalIcon(
                  onPressed: _isGeneratingPdf ? null : _handlePrintInvoice,
                  icon: _isGeneratingPdf
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.print_outlined, size: 18),
                  label: const Text('طباعة الفاتورة / PDF'),
                ),

                // زر مشاركة ملف PDF
                IconButton.filledTonal(
                  onPressed: _isGeneratingPdf ? null : _handleSharePdf,
                  icon: const Icon(Icons.share_outlined, size: 18),
                  tooltip: 'مشاركة ملف الفاتورة PDF',
                ),

                // زر تأكيد الطلب (عندما تكون الحالة قيد الانتظار)
                if (isPending)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isUpdating ? null : _handleConfirmOrder,
                    icon: _isUpdating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline_rounded, size: 18),
                    label: const Text('تأكيد الطلب'),
                  ),

                // زر إلغاء الطلب
                if (canCancel)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(
                        color: colorScheme.error.withValues(alpha: 0.7),
                      ),
                    ),
                    onPressed: _isUpdating
                        ? null
                        : () => _showCancelConfirmationDialog(context),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('إلغاء الطلب'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero Header & Quick Stats ───────────────────────────────────────────
  Widget _buildHeroHeader(BuildContext context, OrderEntity currentOrder) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;
    final dateFormat = intl.DateFormat('yyyy-MM-dd • hh:mm a');

    return Card.outlined(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14.0 : 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Order ID, Date, and Badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'طلب #${currentOrder.id}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Tooltip(
                                  message: 'نسخ رقم الطلب',
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: currentOrder.id));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'تم نسخ رقم الطلب إلى الحافظة'),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.copy_rounded,
                                        size: 15,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OrderStatusBadge(status: currentOrder.status),
                          PaymentStatusBadge(status: currentOrder.paymentStatus),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateFormat.format(currentOrder.orderDate),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tracking Number (if present)
            if (currentOrder.trackingNumber != null &&
                currentOrder.trackingNumber!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 15,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'رقم التتبع: ${currentOrder.trackingNumber}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),

            // Quick Stats Strip
            _buildQuickStatsStrip(context, currentOrder),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsStrip(BuildContext context, OrderEntity currentOrder) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final totalItems =
        currentOrder.items.fold<int>(0, (sum, item) => sum + item.quantity);

    final stats = [
      _QuickStatData(
        icon: Icons.payments_outlined,
        title: 'الإجمالي',
        value: '${currentOrder.totalAmount.toStringAsFixed(2)} ر.س',
        valueColor: colorScheme.primary,
        isBold: true,
      ),
      _QuickStatData(
        icon: Icons.shopping_bag_outlined,
        title: 'المنتجات',
        value:
            '$totalItems ${totalItems == 1 ? 'عنصر' : 'عناصر'} (${currentOrder.items.length} ${currentOrder.items.length == 1 ? 'منتج' : 'منتجات'})',
      ),
      _QuickStatData(
        icon: Icons.credit_card_outlined,
        title: 'طريقة الدفع',
        value: currentOrder.paymentMethod.isNotEmpty
            ? currentOrder.paymentMethod
            : 'غير محدد',
      ),
    ];

    if (isMobile) {
      return Column(
        children: stats
            .map((stat) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(stat.icon,
                          size: 15, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        '${stat.title}:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        stat.value,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: stat.valueColor ?? colorScheme.onSurface,
                          fontWeight:
                              stat.isBold ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    return Row(
      children: stats
          .map((stat) => Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(stat.icon,
                            size: 16, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stat.title,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stat.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: stat.isBold
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: stat.valueColor ?? colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  // ── Products Section ─────────────────────────────────────────────────────
  Widget _buildProductsSection(
    BuildContext context,
    OrderEntity currentOrder,
    bool isDark,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrderCardSection(
      title: 'المنتجات (${currentOrder.items.length})',
      icon: Icons.shopping_bag_outlined,
      padding: EdgeInsets.zero,
      child: currentOrder.items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('لا توجد منتجات في هذا الطلب'),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentOrder.items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
              itemBuilder: (context, index) => OrderItemTile(
                item: currentOrder.items[index],
              ),
            ),
    );
  }

  // ── Order Summary Section ────────────────────────────────────────────────
  Widget _buildSummarySection(
    BuildContext context,
    OrderEntity currentOrder,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrderCardSection(
      title: 'ملخص الطلب',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          OrderSummaryRow(
            label: 'المجموع الفرعي',
            value: '${currentOrder.subtotal.toStringAsFixed(2)} ر.س',
          ),
          OrderSummaryRow(
            label: 'تكلفة الشحن',
            value: '${currentOrder.shippingCost.toStringAsFixed(2)} ر.س',
          ),
          if (currentOrder.discount > 0)
            OrderSummaryRow(
              label: 'الخصم',
              value: '-${currentOrder.discount.toStringAsFixed(2)} ر.س',
              color: colorScheme.error,
            ),
          const SizedBox(height: 4),
          OrderSummaryRow(
            label: 'الإجمالي النهائي',
            value: '${currentOrder.totalAmount.toStringAsFixed(2)} ر.س',
            isTotal: true,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // ── Customer Info Section ────────────────────────────────────────────────
  Widget _buildCustomerSection(
    BuildContext context,
    OrderEntity currentOrder,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final customerName =
        currentOrder.shippingAddress?.fullName?.isNotEmpty == true
            ? currentOrder.shippingAddress!.fullName!
            : (currentOrder.userName.isNotEmpty
                ? currentOrder.userName
                : 'غير محدد');

    final phone = currentOrder.shippingAddress?.phone?.isNotEmpty == true
        ? currentOrder.shippingAddress!.phone!
        : (currentOrder.phoneNumber?.isNotEmpty == true
            ? currentOrder.phoneNumber!
            : 'غير محدد');

    final hasPhone = phone != 'غير محدد' && phone.isNotEmpty;
    final hasEmail = currentOrder.userEmail.isNotEmpty;

    return OrderCardSection(
      title: 'معلومات العميل',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          OrderDetailRow(
            icon: Icons.person_outline,
            label: 'اسم العميل',
            value: customerName,
          ),
          if (hasEmail) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            OrderDetailRow(
              icon: Icons.alternate_email_rounded,
              label: 'البريد الإلكتروني',
              value: currentOrder.userEmail,
              trailing: IconButton(
                icon: const Icon(Icons.mail_outline_rounded, size: 18),
                tooltip: 'إرسال بريد',
                visualDensity: VisualDensity.compact,
                onPressed: () => _sendEmail(context, currentOrder.userEmail),
              ),
            ),
          ],
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          OrderDetailRow(
            icon: Icons.phone_outlined,
            label: 'رقم الهاتف',
            value: phone,
            trailing: hasPhone
                ? IconButton(
                    icon: const Icon(Icons.phone_outlined, size: 18),
                    tooltip: 'اتصال بالعميل',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _makePhoneCall(context, phone),
                  )
                : null,
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          OrderDetailRow(
            icon: Icons.credit_card_outlined,
            label: 'طريقة الدفع',
            value: currentOrder.paymentMethod.isNotEmpty
                ? currentOrder.paymentMethod
                : 'غير محدد',
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          OrderDetailRow(
            icon: Icons.verified_outlined,
            label: 'حالة الدفع',
            value: '',
            trailing: PaymentStatusBadge(status: currentOrder.paymentStatus),
          ),
        ],
      ),
    );
  }

  // ── Shipping Address Section ─────────────────────────────────────────────
  Widget _buildShippingAddressSection(
    BuildContext context,
    OrderEntity currentOrder,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final address = currentOrder.shippingAddress;
    final hasAddress = address != null &&
        (address.hasCoordinates || address.fullAddress.isNotEmpty);

    return OrderCardSection(
      title: 'عنوان الشحن',
      icon: Icons.local_shipping_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderDetailRow(
            icon: Icons.location_on_outlined,
            label: 'العنوان الكامل',
            value: address?.fullAddress ?? "غير متوفر",
            trailing: hasAddress
                ? InkWell(
                    onTap: () => _openGoogleMaps(context, address),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              address.fullAddress.isNotEmpty
                                  ? address.fullAddress
                                  : '${address.latitude}, ${address.longitude}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 15,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          if (address?.city.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            OrderDetailRow(
              icon: Icons.location_city_outlined,
              label: 'المدينة',
              value: address!.city,
            ),
          ],
          if (address?.state?.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            OrderDetailRow(
              icon: Icons.map_outlined,
              label: 'المنطقة / الولاية',
              value: address!.state!,
            ),
          ],
          if (address?.postalCode?.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            OrderDetailRow(
              icon: Icons.markunread_mailbox_outlined,
              label: 'الرمز البريدي',
              value: address!.postalCode!,
            ),
          ],
          if (address?.country?.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            OrderDetailRow(
              icon: Icons.public_outlined,
              label: 'الدولة',
              value: address!.country!,
            ),
          ],
          if (hasAddress) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => _openGoogleMaps(context, address),
                icon: const Icon(Icons.map_rounded, size: 18),
                label: const Text('فتح في خرائط Google'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Notes Section ────────────────────────────────────────────────────────
  Widget _buildNotesSection(BuildContext context, OrderEntity currentOrder) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OrderCardSection(
      title: 'ملاحظات العميل',
      icon: Icons.note_alt_outlined,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          currentOrder.notes!,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  // ── Action Handlers ──────────────────────────────────────────────────────

  /// تأكيد الطلب
  Future<void> _handleConfirmOrder() async {
    await _handleStatusUpdate(OrderStatus.processing);
  }

  /// حوار تأكيد إلغاء الطلب
  Future<void> _showCancelConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: Icon(
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: 36,
        ),
        title: Text(
          'تأكيد إلغاء الطلب',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في إلغاء هذا الطلب رقم #${_order.value.id}؟\nسيتم تغيير حالة الطلب إلى "ملغي".',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('تراجع'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('نعم، إلغاء الطلب'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _handleStatusUpdate(OrderStatus.cancelled);
    }
  }

  /// تنفيذ تحديث الحالة عبر الـ Controller
  Future<void> _handleStatusUpdate(OrderStatus newStatus) async {
    if (_isUpdating) return;
    setState(() => _isUpdating = true);

    try {
      final controller = Get.isRegistered<OrdersController>()
          ? Get.find<OrdersController>()
          : null;

      if (controller != null) {
        final updated =
            await controller.updateOrderStatus(_order.value.id, newStatus);
        if (updated != null) {
          _order.value = updated;
        }
      } else {
        final useCase = Get.isRegistered<UpdateOrderStatusUseCase>()
            ? Get.find<UpdateOrderStatusUseCase>()
            : null;
        if (useCase != null) {
          final updated = await useCase(_order.value.id, newStatus);
          _order.value = updated;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تحديث حالة الطلب بنجاح'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحديث حالة الطلب: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  /// طباعة الفاتورة أو حفظها كـ PDF
  Future<void> _handlePrintInvoice() async {
    setState(() => _isGeneratingPdf = true);
    try {
      await InvoicePdfService.printInvoice(_order.value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر إنشاء الفاتورة: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  /// مشاركة ملف PDF
  Future<void> _handleSharePdf() async {
    setState(() => _isGeneratingPdf = true);
    try {
      await InvoicePdfService.shareInvoice(_order.value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر مشاركة ملف الفاتورة: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  // ── External Actions ─────────────────────────────────────────────────────
  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر إجراء المكالمة')),
        );
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح تطبيق البريد')),
        );
      }
    }
  }

  Future<void> _openGoogleMaps(
    BuildContext context,
    AddressEntity address,
  ) async {
    final String query = address.hasCoordinates
        ? '${address.latitude},${address.longitude}'
        : address.fullAddress;

    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عنوان الشحن غير متوفر')),
      );
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح خرائط Google')),
        );
      }
    }
  }
}

class _QuickStatData {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _QuickStatData({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });
}
