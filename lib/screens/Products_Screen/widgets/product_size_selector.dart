import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final Function(List<String>) onSelectionChanged;

  // الأحجام الافتراضية الشائعة في عالم المكملات
  final List<String> availableSizes = [
    '500g', '1kg', '2kg', '5kg', 
    '2lb', '5lb', '10lb', 
    '30 Servings', '60 Servings', '120 Caps',
    'Medium', 'Large', 'Small'
  ];

  ProductSizeSelector({
    super.key,
    required this.selectedSizes,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // دمج الأحجام الثابتة مع أي أحجام مخصصة اختارها المستخدم
    final combinedSizes = {...availableSizes, ...selectedSizes}.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "الأحجام / الأوزان المتوفرة لهذا المنتج",
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
              // عرض الأحجام كـ FilterChips
              ...combinedSizes.map((size) {
                final isSelected = selectedSizes.contains(size);
                return FilterChip(
                  label: Text(size),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    List<String> updatedList = List.from(selectedSizes);
                    if (selected) {
                      updatedList.add(size);
                    } else {
                      updatedList.remove(size);
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
              
              // زر إضافة حجم مخصص (ActionChip)
              ActionChip(
                avatar: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: const Text("حجم مخصص", style: TextStyle(fontSize: 12)),
                onPressed: () => _showAddSizeDialog(context),
                backgroundColor: AppColors.primary.withOpacity(0.05),
                shape: const StadiumBorder(side: BorderSide(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // نافذة إضافة حجم جديد
  void _showAddSizeDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة حجم/وزن جديد", style: TextStyle(fontSize: 16)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "مثلاً: 1.5kg أو 180 Tabs",
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
              final newSize = controller.text.trim();
              if (newSize.isNotEmpty && !selectedSizes.contains(newSize)) {
                onSelectionChanged([...selectedSizes, newSize]);
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