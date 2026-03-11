import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/chipItem.dart';

class HorizontalChipsSelector extends StatelessWidget {
  final List<dynamic> items;
  final String selectedId;
  final Function(String id) onSelect;
  final String labelKey;
  final String idKey;
  final bool showAllOption;
  final String allLabel;

  final String Function(dynamic item)? labelBuilder;
  final String Function(dynamic item)? idBuilder;

  const HorizontalChipsSelector({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelect,
    this.labelKey = 'name',
    this.idKey = 'id',
    this.showAllOption = true,
    this.allLabel = 'الكل',
    this.labelBuilder,
    this.idBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.defaultPadding.left,
        ),
        itemCount: showAllOption ? items.length + 1 : items.length,
        itemBuilder: (context, index) {
          final bool isAllItem = showAllOption && index == 0;

          final String displayLabel = isAllItem
              ? allLabel
              : labelBuilder != null
              ? labelBuilder!(items[showAllOption ? index - 1 : index])
              : _getValue(items[showAllOption ? index - 1 : index], labelKey);

          final String itemId = isAllItem
              ? 'all'
              : idBuilder != null
              ? idBuilder!(items[showAllOption ? index - 1 : index])
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

  String _getValue(dynamic item, String key) {
    if (item == null) return '';
    
    // 1. Try Map access
    if (item is Map) return item[key]?.toString() ?? '';

    // 2. Try common entity properties directly if key is known
    if (key == 'id') {
      try { return item.id.toString(); } catch (_) {}
    }

    // 3. Try toJson logic
    try {
      return item.toJson()[key]?.toString() ?? '';
    } catch (_) {
      // 4. Final fallback to dynamic access (might fail on classes)
      try {
        return item[key]?.toString() ?? '';
      } catch (_) {
        return '';
      }
    }
  }
}
