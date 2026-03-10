import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<ProductSizeEntity> selectedSizes;
  final void Function(List<ProductSizeEntity>) onSelectionChanged;
  final Function(int) onSelectSize;
  final int selectedIndex;
  final double defaultPrice;

  final List<String> availableSizes = [
    '500g',
    '1kg',
    '2kg',
    '4kg',
    '3kg',
    '5kg',
    '2lb',
    '5lb',
    '10lb',
    '30 Servings',
    '60 Servings',
    '100 Servings',
    '120 Caps',
    'Medium',
    'Large',
    'Small',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "الأحجام / الأوزان المختارة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                ),
                tooltip: "إضافة من القائمة",
                onSelected: (String sizeName) {
                  if (!selectedSizes.any((s) => s.size == sizeName)) {
                    List<ProductSizeEntity> updatedList =
                        List<ProductSizeEntity>.from(
                      selectedSizes,
                    );
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
          const SizedBox(height: 10),
          GlassContainer(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // عرض الأحجام المختارة فقط
                ...selectedSizes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sizeObj = entry.value;
                  final isActive = index == selectedIndex;

                  return InputChip(
                    avatar: isActive
                        ? const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.primary,
                          )
                        : null,
                    label: Text(sizeObj.size),
                    selected: isActive,
                    onSelected: (bool selected) {
                      onSelectSize(index);
                    },
                    onDeleted: () {
                      List<ProductSizeEntity> updatedList =
                          List<ProductSizeEntity>.from(
                        selectedSizes,
                      );
                      updatedList.removeAt(index);
                      onSelectionChanged(updatedList);
                      onSelectSize(-1);
                    },
                    deleteIconColor: Colors.redAccent,
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: isActive
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isActive
                            ? AppColors.primary
                            : Colors.grey.withValues(alpha: 0.3),
                        width: isActive ? 2 : 1,
                      ),
                    ),
                  );
                }),

                // زر إضافة حجم مخصص (ActionChip)
                ActionChip(
                  avatar: const Icon(
                    Icons.edit_note,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: const Text("حجم مخصص", style: TextStyle(fontSize: 12)),
                  onPressed: () => _showAddSizeDialog(context),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                  shape: const StadiumBorder(
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // نافذة إضافة حجم جديد
  void _showAddSizeDialog(BuildContext context) {
    final TextEditingController sizeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة حجم/وزن جديد", style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: sizeController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "مثلاً: 1.5kg أو 180 Tabs",
            labelText: "الحجم",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
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
