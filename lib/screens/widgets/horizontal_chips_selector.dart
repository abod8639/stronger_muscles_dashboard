import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/chipItem.dart';

class HorizontalChipsSelector extends StatelessWidget {
  final List<dynamic> items; // قائمة العناصر (Categories, Flavors, etc.)
  final String selectedId; // المعرف المختار حالياً
  final Function(String id) onSelect; // ماذا يحدث عند الضغط
  final String labelKey; // اسم الحقل الذي يحتوي على النص (مثلاً 'name')
  final String idKey; // اسم الحقل الذي يحتوي على المعرف (مثلاً 'id')
  final bool showAllOption; // هل تريد إظهار خيار "الكل"؟
  final String allLabel; // نص خيار "الكل"

  const HorizontalChipsSelector({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelect,
    this.labelKey = 'name',
    this.idKey = 'id',
    this.showAllOption = true,
    this.allLabel = 'الكل',
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      height: 50, // تقليل الارتفاع قليلاً ليكون أكثر رشاقة
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.defaultPadding.left,
        ),
        // زيادة العدد بمقدار 1 إذا كان خيار "الكل" مفعلاً
        itemCount: showAllOption ? items.length + 1 : items.length,
        itemBuilder: (context, index) {
          final bool isAllItem = showAllOption && index == 0;

          // استخراج البيانات بناءً على كون العنصر هو "الكل" أو عنصر من القائمة
          final String displayLabel = isAllItem
              ? allLabel
              : _getValue(items[showAllOption ? index - 1 : index], labelKey);

          final String itemId = isAllItem
              ? 'all'
              : _getValue(items[showAllOption ? index - 1 : index], idKey);

          final bool isSelected = selectedId == itemId;

          return ChipItem(
            label: displayLabel,
            isSelected: isSelected,
            onTap: () => onSelect(itemId),
            index: index,
          );
        },
      ),
    );
  }

  // دالة مساعدة لاستخراج القيمة من Object أو Map
  String _getValue(dynamic item, String key) {
    try {
      return item.toJson()[key]?.toString() ?? '';
    } catch (_) {
      // إذا لم يكن Model يحتوي على toJson (مثل Map عادية)
      return item[key]?.toString() ?? '';
    }
  }
}
