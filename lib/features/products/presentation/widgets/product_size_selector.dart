import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'flavor_multi_select.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<ProductSizeEntity> selectedSizes;
  final void Function(List<ProductSizeEntity>) onSelectionChanged;
  final Function(int) onSelectSize;
  final int selectedIndex;
  final double defaultPrice;
  final List<String> availableFlavors;

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
    '120 Servings',
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
    this.availableFlavors = const [],
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
                      final updatedList = List<ProductSizeEntity>.from(
                        selectedSizes,
                      );
                      int? defaultServings;
                      String? defaultWeight;
                      if (sizeName.toLowerCase().contains('serving')) {
                        defaultServings = int.tryParse(
                          sizeName.replaceAll(RegExp(r'[^0-9]'), ''),
                        );
                      } else {
                        defaultWeight = sizeName;
                      }

                      updatedList.add(
                        ProductSizeEntity(
                          size: sizeName,
                          price: defaultPrice,
                          servings: defaultServings,
                          weight: defaultWeight,
                          flavors: availableFlavors.isNotEmpty
                              ? List<String>.from(availableFlavors)
                              : null,
                        ),
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
                  final flavorCount = sizeObj.flavors?.length ?? 0;

                  return InputChip(
                    
                    avatar: isActive
                        ? Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          )
                        : null,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sizeObj.size),
                        if (flavorCount > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? colorScheme.primary.withValues(alpha: 0.18)
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$flavorCount نكهة',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    selected: isActive,
                    onSelected: (bool selected) {
                      onSelectSize(index);
                    },
                    onDeleted: () {
                      final updatedList = List<ProductSizeEntity>.from(
                        selectedSizes,
                      );
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
    final List<String> selectedCustomFlavors =
        availableFlavors.isNotEmpty ? List<String>.from(availableFlavors) : [];

    final List<FlavorItem> allFlavors =
        List<FlavorItem>.from(ProductFlavorSelector.defaultPresets);
    for (final raw in availableFlavors) {
      final item = FlavorItem.fromRaw(raw);
      if (!allFlavors
          .any((f) => f.name.toLowerCase() == item.name.toLowerCase())) {
        allFlavors.add(item);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.straighten_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Text("إضافة حجم مخصص واختيار نكهاته"),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: sizeController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "مثلاً: 1.5kg أو 180 Tabs أو 4 Lbs",
                        labelText: "اسم الحجم المخصص",
                        prefixIcon: Icon(Icons.straighten_rounded),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "النكهات الخاصة بهذا الحجم:",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (allFlavors.isNotEmpty)
                          TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                if (selectedCustomFlavors.length ==
                                    allFlavors.length) {
                                  selectedCustomFlavors.clear();
                                } else {
                                  selectedCustomFlavors
                                    ..clear()
                                    ..addAll(allFlavors.map((e) => e.rawValue));
                                }
                              });
                            },
                            child: Text(
                              selectedCustomFlavors.length == allFlavors.length
                                  ? 'إلغاء تحديد الكل'
                                  : 'تحديد الكل',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allFlavors.map((item) {
                        final isSelected = selectedCustomFlavors.any(
                          (raw) =>
                              FlavorItem.fromRaw(raw).name.toLowerCase() ==
                              item.name.toLowerCase(),
                        );
                        return FilterChip(
                          avatar: item.imageUrl != null &&
                                  item.imageUrl!.trim().isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: item.imageUrl!,
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, _, _) => const Icon(
                                      Icons.icecream_outlined,
                                      size: 14,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.icecream_outlined, size: 14),
                          label: Text(item.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedCustomFlavors.add(item.rawValue);
                              } else {
                                selectedCustomFlavors.removeWhere(
                                  (raw) =>
                                      FlavorItem.fromRaw(
                                        raw,
                                      ).name.toLowerCase() ==
                                      item.name.toLowerCase(),
                                );
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
                    int? defaultServings;
                    String? defaultWeight;
                    if (newSize.toLowerCase().contains('serving')) {
                      defaultServings = int.tryParse(
                        newSize.replaceAll(RegExp(r'[^0-9]'), ''),
                      );
                    } else {
                      defaultWeight = newSize;
                    }

                    final updatedList = [
                      ...selectedSizes,
                      ProductSizeEntity(
                        size: newSize,
                        price: defaultPrice,
                        servings: defaultServings,
                        weight: defaultWeight,
                        flavors: selectedCustomFlavors.isNotEmpty
                            ? selectedCustomFlavors
                            : null,
                      ),
                    ];
                    onSelectionChanged(updatedList);
                    onSelectSize(updatedList.length - 1);
                  }
                  Navigator.pop(context);
                },
                child: const Text("إضافة الحجم"),
              ),
            ],
          ),
        );
      },
    );
  }
}
