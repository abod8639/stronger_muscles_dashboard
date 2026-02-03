import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_addressInfo_row.dart';

Widget buildAddressSection(Map<String, dynamic>? snapshot) {
  if (snapshot == null || snapshot.isEmpty) {
    return const Text(
      'العنوان غير متوفر',
      style: TextStyle(color: Colors.grey),
    );
  }

  if (snapshot.containsKey('address')) {
    final addr = snapshot['address'];
    if (addr is String) {
      return buildAddressInfoRow(Icons.location_on, 'العنوان الكامل', addr);
    }
    if (addr is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAddressInfoRow(
            Icons.location_city,
            'المدينة',
            addr['city'] ?? addr['City'] ?? 'غير محدد',
          ),
          const SizedBox(height: 12),
          buildAddressInfoRow(
            Icons.location_on,
            'الشارع/العنوان',
            addr['street'] ?? addr['Street'] ?? 'غير محدد',
          ),
        ],
      );
    }
  }

  final firstVal = snapshot.values.isNotEmpty ? snapshot.values.first : null;
  if (firstVal is String) {
    return buildAddressInfoRow(Icons.location_on, 'العنوان الكامل', firstVal);
  }
  if (firstVal is Map) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAddressInfoRow(
          Icons.location_city,
          'المدينة',
          firstVal['city'] ?? firstVal['City'] ?? 'غير محدد',
        ),
        const SizedBox(height: 12),
        buildAddressInfoRow(
          Icons.location_on,
          'الشارع/العنوان',
          firstVal['street'] ?? firstVal['Street'] ?? 'غير محدد',
        ),
      ],
    );
  }

  return const Text('العنوان غير محدد', style: TextStyle(color: Colors.grey));
}
