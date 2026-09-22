import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 960;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
      appBar: BaseAppBar(
        title: 'تفاصيل الطلب #${order.id}',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 28.0 : 16.0,
          vertical: 16.0,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroHeader(context),
                const SizedBox(height: 16),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Products & Notes
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
                      // Right Column: Summary, Customer, Shipping
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
                  Column(
                    children: [
                      _buildProductsSection(context, isDark),
                      const SizedBox(height: 16),
                      _buildSummarySection(context),
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

  // ── Hero Header ──────────────────────────────────────────────────────────
  Widget _buildHeroHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'طلب #${order.id}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'نسخ رقم الطلب',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: order.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم نسخ رقم الطلب إلى الحافظة'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateFormat.format(order.orderDate),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OrderStatusBadge(status: order.status),
                    PaymentStatusBadge(status: order.paymentStatus),
                  ],
                ),
              ],
            ),
            if (order.trackingNumber != null &&
                order.trackingNumber!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'رقم التتبع: ${order.trackingNumber}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
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
              itemBuilder: (context, index) => buildOrderItem(
                order.items[index],
                isDark,
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
          buildSummaryRow(
            'المجموع الفرعي',
            '${order.subtotal.toStringAsFixed(2)} ر.س',
          ),
          buildSummaryRow(
            'تكلفة الشحن',
            '${order.shippingCost.toStringAsFixed(2)} ر.س',
          ),
          if (order.discount > 0)
            buildSummaryRow(
              'الخصم',
              '-${order.discount.toStringAsFixed(2)} ر.س',
              color: colorScheme.error,
            ),
          const SizedBox(height: 4),
          buildSummaryRow(
            'الإجمالي',
            '${order.totalAmount.toStringAsFixed(2)} ر.س',
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

    return OrderCardSection(
      title: 'معلومات العميل',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          buildDetailRow(
            Icons.person_outline,
            'اسم العميل',
            customerName,
          ),
          if (order.userEmail.isNotEmpty) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            buildDetailRow(
              Icons.alternate_email_rounded,
              'البريد الإلكتروني',
              order.userEmail,
            ),
          ],
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          buildDetailRow(
            Icons.phone_outlined,
            'رقم الهاتف',
            phone,
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          buildDetailRow(
            Icons.credit_card_outlined,
            'طريقة الدفع',
            order.paymentMethod.isNotEmpty ? order.paymentMethod : 'غير محدد',
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          buildDetailRow(
            Icons.verified_outlined,
            'حالة الدفع',
            '',
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
          buildDetailRow(
            Icons.location_on_outlined,
            'العنوان الكامل',
            address?.fullAddress ?? "غير متوفر",
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
            buildDetailRow(
              Icons.location_city_outlined,
              'المدينة',
              address!.city,
            ),
          ],
          if (address?.state?.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            buildDetailRow(
              Icons.map_outlined,
              'المنطقة / الولاية',
              address!.state!,
            ),
          ],
          if (address?.postalCode?.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            buildDetailRow(
              Icons.markunread_mailbox_outlined,
              'الرمز البريدي',
              address!.postalCode!,
            ),
          ],
          if (address?.country?.isNotEmpty == true) ...[
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            buildDetailRow(
              Icons.public_outlined,
              'الدولة',
              address!.country!,
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

  // ── Google Maps Launcher ─────────────────────────────────────────────────
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
