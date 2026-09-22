import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<ProductSizeEntity> selectedSizes;
  final void Function(List<ProductSizeEntity>) onSelectionChanged;
  final Function(int) onSelectSize;
  final int selectedIndex;
  final double defaultPrice;

  final List<String> availableSizes = [
    '500g', '1kg', '2kg', '4kg', '3kg', '5kg',
    '2lb', '5lb', '10lb',
    '30 Servings', '60 Servings', '100 Servings', '120 Servings',
    '120 Caps', 'Medium', 'Large', 'Small',
  ];

  ProductSizeSelector({
    super.key,
    required this.selectedSizes,
    required this.onSelectionChanged,
    required this.onSelectSize,
    required this.selectedIndex,
    this.defaultPrice = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.straighten_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "الأحجام / الأوزان المتوفرة",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: colorScheme.primary,
                  ),
                  tooltip: "إضافة من القائمة",
                  onSelected: (String sizeName) {
                    if (!selectedSizes.any((s) => s.size == sizeName)) {
                      final updatedList = List<ProductSizeEntity>.from(selectedSizes);
                      updatedList.add(
                        ProductSizeEntity(size: sizeName, price: defaultPrice),
                      );
                      onSelectionChanged(updatedList);
                      onSelectSize(updatedList.length - 1);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return availableSizes
                        .where(
                          (size) => !selectedSizes.any((s) => s.size == size),
                        )
                        .map((String size) {
                          return PopupMenuItem<String>(
                            value: size,
                            child: Text(size),
                          );
                        })
                        .toList();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...selectedSizes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sizeObj = entry.value;
                  final isActive = index == selectedIndex;

                  return InputChip(
                    avatar: isActive
                        ? Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          )
                        : null,
                    label: Text(sizeObj.size),
                    selected: isActive,
                    onSelected: (bool selected) {
                      onSelectSize(index);
                    },
                    onDeleted: () {
                      final updatedList = List<ProductSizeEntity>.from(selectedSizes);
                      updatedList.removeAt(index);
                      onSelectionChanged(updatedList);
                      onSelectSize(-1);
                    },
                    deleteIconColor: colorScheme.error,
                  );
                }),

                ActionChip(
                  avatar: Icon(
                    Icons.edit_note_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  label: const Text("حجم مخصص"),
                  onPressed: () => _showAddSizeDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSizeDialog(BuildContext context) {
    final TextEditingController sizeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة حجم/وزن مخصص"),
        content: TextField(
          controller: sizeController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "مثلاً: 1.5kg أو 180 Tabs",
            labelText: "الحجم",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          FilledButton(
            onPressed: () {
              final newSize = sizeController.text.trim();
              if (newSize.isNotEmpty &&
                  !selectedSizes.any((s) => s.size == newSize)) {
                final updatedList = [
                  ...selectedSizes,
                  ProductSizeEntity(size: newSize, price: defaultPrice),
                ];
                onSelectionChanged(updatedList);
                onSelectSize(updatedList.length - 1);
              }
              Navigator.pop(context);
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }
}
