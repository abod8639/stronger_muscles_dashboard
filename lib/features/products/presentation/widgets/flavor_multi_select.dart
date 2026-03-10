import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class ProductFlavorSelector extends StatelessWidget {
  final List<String> selectedFlavors;
  final void Function(List<String>) onSelectionChanged;

  final List<String> availableFlavors = [
    'Vanilla',
    'Strawberry',
    'Chocolate',
    'Mango',
    'Caramel',
    'Coffee',
    'Berry',
    'Cola',
    'Peanut',
    'Watermelon',
    'No Flavor',
  ];

  ProductFlavorSelector({
    super.key,
    required this.selectedFlavors,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // دمج النكهات الثابتة مع أي نكهات مخصصة تمت إضافتها سابقاً
    final combinedFlavors = {...availableFlavors, ...selectedFlavors}.toList();

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "النكهات المتوفرة لهذا المنتج",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          GlassContainer(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...combinedFlavors.map((flavor) {
                  final isSelected = selectedFlavors.contains(flavor);
                  return FilterChip(
                    label: Text(flavor),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      List<String> updatedList = List<String>.from(
                        selectedFlavors,
                      );
                      if (selected) {
                        updatedList.add(flavor);
                      } else {
                        updatedList.remove(flavor);
                      }
                      onSelectionChanged(updatedList);
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                }),

                // زر إضافة نكهة جديدة
                ActionChip(
                  avatar: const Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: const Text("نكهة مخصصة"),
                  onPressed: () => _showAddFlavorDialog(context),
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

  // نافذة إضافة نكهة جديدة
  void _showAddFlavorDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة نكهة جديدة", style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "مثلاً: Pistachio",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            autofocus: true,
            onPressed: () {
              final newFlavor = controller.text.trim();
              if (newFlavor.isNotEmpty &&
                  !selectedFlavors.contains(newFlavor)) {
                onSelectionChanged([...selectedFlavors, newFlavor]);
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
