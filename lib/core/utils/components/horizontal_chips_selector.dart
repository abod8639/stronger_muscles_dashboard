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
    try {
      return item.toJson()[key]?.toString() ?? '';
    } catch (_) {
      return item[key]?.toString() ?? '';
    }
  }
}
