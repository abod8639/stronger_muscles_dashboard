import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final combinedFlavors = {...availableFlavors, ...selectedFlavors}.toList();

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
              children: [
                Icon(
                  Icons.icecream_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "النكهات المتوفرة لهذا المنتج",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...combinedFlavors.map((flavor) {
                  final isSelected = selectedFlavors.contains(flavor);
                  return FilterChip(
                    label: Text(flavor),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      final updatedList = List<String>.from(selectedFlavors);
                      if (selected) {
                        updatedList.add(flavor);
                      } else {
                        updatedList.remove(flavor);
                      }
                      onSelectionChanged(updatedList);
                    },
                  );
                }),

                // زر إضافة نكهة جديدة
                ActionChip(
                  avatar: Icon(
                    Icons.add,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  label: const Text("نكهة مخصصة"),
                  onPressed: () => _showAddFlavorDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFlavorDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة نكهة جديدة"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "مثلاً: Pistachio",
            labelText: "اسم النكهة",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          FilledButton(
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
