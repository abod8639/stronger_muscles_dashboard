import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';
import 'order_card_section.dart';
import 'order_detail_row.dart';

/// بطاقة عنوان الشحن وبيانات الموقع الجغرافي
class OrderShippingSection extends StatelessWidget {
  final OrderEntity order;
  final OrderDetailsController controller;

  const OrderShippingSection({
    super.key,
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
            value: address?.fullAddress ?? 'غير متوفر',
            trailing: hasAddress
                ? InkWell(
                    onTap: () => controller.openGoogleMaps(address),
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
                onPressed: () => controller.openGoogleMaps(address),
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
}
