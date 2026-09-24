import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_detail_row.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_order_item.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_section.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/widget/build_summary_row.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 960;
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: 'تفاصيل الطلب #${order.id}',
        centerTitle: true,
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
                _buildHeroHeader(context),
                const SizedBox(height: 16),

                // 2. Rearranged Content Grid
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Column (Flex 3): Products & Notes
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildProductsSection(context, isDark),
                            if (order.notes != null &&
                                order.notes!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _buildNotesSection(context),
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
                            _buildSummarySection(context),
                            const SizedBox(height: 16),
                            _buildCustomerSection(context),
                            const SizedBox(height: 16),
                            _buildShippingAddressSection(context),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // Mobile Layout: Summary first for quick financial overview, then products, customer, shipping
                  Column(
                    children: [
                      _buildSummarySection(context),
                      const SizedBox(height: 16),
                      _buildProductsSection(context, isDark),
                      const SizedBox(height: 16),
                      _buildCustomerSection(context),
                      const SizedBox(height: 16),
                      _buildShippingAddressSection(context),
                      if (order.notes != null &&
                          order.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildNotesSection(context),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Hero Header & Quick Stats ───────────────────────────────────────────
  Widget _buildHeroHeader(BuildContext context) {
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
                                  'طلب #${order.id}',
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
                                          ClipboardData(text: order.id));
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
                          OrderStatusBadge(status: order.status),
                          PaymentStatusBadge(status: order.paymentStatus),
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
                            dateFormat.format(order.orderDate),
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
            if (order.trackingNumber != null &&
                order.trackingNumber!.isNotEmpty) ...[
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
                      'رقم التتبع: ${order.trackingNumber}',
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
            _buildQuickStatsStrip(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsStrip(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final totalItems =
        order.items.fold<int>(0, (sum, item) => sum + item.quantity);

    final stats = [
      _QuickStatData(
        icon: Icons.payments_outlined,
        title: 'الإجمالي',
        value: '${order.totalAmount.toStringAsFixed(2)} ر.س',
        valueColor: colorScheme.primary,
        isBold: true,
      ),
      _QuickStatData(
        icon: Icons.shopping_bag_outlined,
        title: 'المنتجات',
        value:
            '$totalItems ${totalItems == 1 ? 'عنصر' : 'عناصر'} (${order.items.length} ${order.items.length == 1 ? 'منتج' : 'منتجات'})',
      ),
      _QuickStatData(
        icon: Icons.credit_card_outlined,
        title: 'طريقة الدفع',
        value:
            order.paymentMethod.isNotEmpty ? order.paymentMethod : 'غير محدد',
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
  Widget _buildProductsSection(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrderCardSection(
      title: 'المنتجات (${order.items.length})',
      icon: Icons.shopping_bag_outlined,
      padding: EdgeInsets.zero,
      child: order.items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('لا توجد منتجات في هذا الطلب'),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
              itemBuilder: (context, index) => OrderItemTile(
                item: order.items[index],
              ),
            ),
    );
  }

  // ── Order Summary Section ────────────────────────────────────────────────
  Widget _buildSummarySection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OrderCardSection(
      title: 'ملخص الطلب',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          OrderSummaryRow(
            label: 'المجموع الفرعي',
            value: '${order.subtotal.toStringAsFixed(2)} ر.س',
          ),
          OrderSummaryRow(
            label: 'تكلفة الشحن',
            value: '${order.shippingCost.toStringAsFixed(2)} ر.س',
          ),
          if (order.discount > 0)
            OrderSummaryRow(
              label: 'الخصم',
              value: '-${order.discount.toStringAsFixed(2)} ر.س',
              color: colorScheme.error,
            ),
          const SizedBox(height: 4),
          OrderSummaryRow(
            label: 'الإجمالي النهائي',
            value: '${order.totalAmount.toStringAsFixed(2)} ر.س',
            isTotal: true,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // ── Customer Info Section ────────────────────────────────────────────────
  Widget _buildCustomerSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customerName = order.shippingAddress?.fullName?.isNotEmpty == true
        ? order.shippingAddress!.fullName!
        : (order.userName.isNotEmpty ? order.userName : 'غير محدد');

    final phone = order.shippingAddress?.phone?.isNotEmpty == true
        ? order.shippingAddress!.phone!
        : (order.phoneNumber?.isNotEmpty == true
            ? order.phoneNumber!
            : 'غير محدد');

    final hasPhone = phone != 'غير محدد' && phone.isNotEmpty;
    final hasEmail = order.userEmail.isNotEmpty;

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
              value: order.userEmail,
              trailing: IconButton(
                icon: const Icon(Icons.mail_outline_rounded, size: 18),
                tooltip: 'إرسال بريد',
                visualDensity: VisualDensity.compact,
                onPressed: () => _sendEmail(context, order.userEmail),
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
            value: order.paymentMethod.isNotEmpty
                ? order.paymentMethod
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
            trailing: PaymentStatusBadge(status: order.paymentStatus),
          ),
        ],
      ),
    );
  }

  // ── Shipping Address Section ─────────────────────────────────────────────
  Widget _buildShippingAddressSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final address = order.shippingAddress;
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
  Widget _buildNotesSection(BuildContext context) {
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
          order.notes!,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
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
