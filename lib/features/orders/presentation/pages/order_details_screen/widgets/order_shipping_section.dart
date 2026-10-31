import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/core/components/divided_column.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/order_details_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/detail_row.dart';

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
    final coords = controller.resolveCoordinates(address);
    final hasCoords = coords != null;
    final hasAddress =
        hasCoords || (address != null && address.fullAddress.isNotEmpty);

    return SectionCard(
      title: 'عنوان الشحن',
      icon: Icons.local_shipping_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DividedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRow(
                icon: Icons.location_on_outlined,
                label: 'العنوان الكامل',
                value: address?.fullAddress.isNotEmpty == true
                    ? address!.fullAddress
                    : (hasCoords
                        ? '${coords.$1}, ${coords.$2}'
                        : 'غير متوفر'),
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
                                  address?.fullAddress.isNotEmpty == true
                                      ? address!.fullAddress
                                      : (hasCoords
                                          ? '${coords.$1.toStringAsFixed(6)}, ${coords.$2.toStringAsFixed(6)}'
                                          : 'فتح الخريطة'),
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
              if (hasCoords)
                DetailRow(
                  icon: Icons.my_location_rounded,
                  label: 'إحداثيات العميل (GPS)',
                  value:
                      '${coords.$1.toStringAsFixed(6)}, ${coords.$2.toStringAsFixed(6)}',
                  trailing: InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: '${coords.$1}, ${coords.$2}'),
                      );
                      AppFeedback.showSuccess('تم نسخ إحداثيات الموقع');
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${coords.$1.toStringAsFixed(6)}, ${coords.$2.toStringAsFixed(6)}',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.copy_rounded,
                            size: 15,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (address?.city.isNotEmpty == true)
                DetailRow(
                  icon: Icons.location_city_outlined,
                  label: 'المدينة',
                  value: address!.city,
                ),
              if (address?.state?.isNotEmpty == true)
                DetailRow(
                  icon: Icons.map_outlined,
                  label: 'المنطقة / الولاية',
                  value: address!.state!,
                ),
              if (address?.postalCode?.isNotEmpty == true)
                DetailRow(
                  icon: Icons.markunread_mailbox_outlined,
                  label: 'الرمز البريدي',
                  value: address!.postalCode!,
                ),
              if (address?.country?.isNotEmpty == true)
                DetailRow(
                  icon: Icons.public_outlined,
                  label: 'الدولة',
                  value: address!.country!,
                ),
            ],
          ),
          if (hasAddress) ...[
            const SizedBox(height: AppDesignTokens.space16),
            FilledButton.tonalIcon(
              onPressed: () => controller.openGoogleMaps(address),
              icon: Icon(
                hasCoords ? Icons.pin_drop_rounded : Icons.map_rounded,
                size: 18,
              ),
              label: Text(
                hasCoords
                    ? 'فتح إحداثيات العميل في خرائط Google'
                    : 'فتح في خرائط Google',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
