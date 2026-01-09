import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class ProductFlavorSelector extends StatelessWidget {
  final List<String> selectedFlavors;
  final Function(List<String>) onSelectionChanged;

  // قائمة النكهات الثابتة لمجال المكملات
  final List<String> availableFlavors = [
    'Vanilla', 'Strawberry', 
    'Choco', 'Mango', 
    'Caramel', 'Coffee', 
    'Vanilla Cream', 'Tot', 
    'No Flavor'
  ];

  ProductFlavorSelector({
    super.key,
    required this.selectedFlavors,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Text(
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
            children: availableFlavors.map((flavor) {
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
                ),
                backgroundColor: Colors.transparent,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}