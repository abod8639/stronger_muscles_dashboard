import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class ProductFlavorSelector extends StatelessWidget {
  final List<String> selectedFlavors;
  final Function(List<String>) onSelectionChanged;

  final List<String> availableFlavors = [
    'Vanilla', 'Strawberry', 'Choco', 'Mango', 
    'Caramel', 'Coffee', 'Vanilla Cream', 'Tot', 'No Flavor'
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "النكهات المتوفرة لهذا المنتج",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // عرض النكهات الموجودة
              ...combinedFlavors.map((flavor) {
                final isSelected = selectedFlavors.contains(flavor);
                return FilterChip(
                  label: Text(flavor),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    List<String> updatedList = List.from(selectedFlavors);
                    if (selected) {
                      updatedList.add(flavor);
                    } else {
                      updatedList.remove(flavor);
                    }
                    onSelectionChanged(updatedList);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                );
              }),
              
              // زر إضافة نكهة جديدة
              ActionChip(
                avatar: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: const Text("نكهة مخصصة"),
                onPressed: () => _showAddFlavorDialog(context),
                backgroundColor: AppColors.primary.withOpacity(0.05),
                shape: const StadiumBorder(side: BorderSide(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ],
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
            onPressed: () {
              final newFlavor = controller.text.trim();
              if (newFlavor.isNotEmpty && !selectedFlavors.contains(newFlavor)) {
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