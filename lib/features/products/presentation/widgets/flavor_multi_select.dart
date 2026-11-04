import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/flavor_item.dart';

export 'package:stronger_muscles_dashboard/features/products/domain/entities/flavor_item.dart';

class ProductFlavorSelector extends StatelessWidget {
  final List<String> selectedFlavors;
  final void Function(List<String>) onSelectionChanged;
  final String? activeSizeName;
  final VoidCallback? onApplyToAllSizes;

  /// النكهات المعتمدة في المتجر
  static List<FlavorItem> get defaultPresets => FlavorItem.defaultPresets;

  const ProductFlavorSelector({
    super.key,
    required this.selectedFlavors,
    required this.onSelectionChanged,
    this.activeSizeName,
    this.onApplyToAllSizes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedItems = selectedFlavors.map(FlavorItem.fromRaw).toList();

    // دمج النكهات الافتراضية مع النكهات المحددة مع إعطاء الأولوية للنكهات المخصصة
    final Map<String, FlavorItem> combinedMap = {};
    for (final preset in defaultPresets) {
      combinedMap[preset.name.toLowerCase()] = preset;
    }
    for (final selected in selectedItems) {
      combinedMap[selected.name.toLowerCase()] = selected;
    }

    final combinedList = combinedMap.values.toList();

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
                      Icons.icecream_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      activeSizeName != null
                          ? "نكهات الحجم المحدد ($activeSizeName)"
                          : "النكهات المتوفرة لهذا المنتج",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (activeSizeName != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'خاص بالحجم',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (onApplyToAllSizes != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    onPressed: onApplyToAllSizes,
                    icon: const Icon(Icons.copy_all_rounded, size: 16),
                    label: const Text(
                      'تطبيق على كل الأحجام',
                      style: TextStyle(fontSize: 11),
                    ),
                  )
                else
                  Text(
                    'انقر للتحديد، واضغط مطولاً لتعديل الصورة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...combinedList.map((item) {
                  final isSelected = selectedItems.any(
                    (s) => s.name.toLowerCase() == item.name.toLowerCase(),
                  );

                  return InkWell(
                    onLongPress: () =>
                        _showAddOrEditFlavorDialog(context, initialItem: item),
                    borderRadius: BorderRadius.circular(20),
                    child: FilterChip(
                      avatar: item.imageUrl != null &&
                              item.imageUrl!.trim().isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl!,
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                                errorWidget: (_, _, _) => Icon(
                                  Icons.icecream_outlined,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.icecream_outlined,
                              size: 16,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                      label: Text(item.name),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        final updatedList = List<String>.from(selectedFlavors);
                        if (selected) {
                          updatedList.add(item.rawValue);
                        } else {
                          updatedList.removeWhere(
                            (raw) =>
                                FlavorItem.fromRaw(raw).name.toLowerCase() ==
                                item.name.toLowerCase(),
                          );
                        }
                        onSelectionChanged(updatedList);
                      },
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrEditFlavorDialog(
    BuildContext context, {
    FlavorItem? initialItem,
  }) {
    final TextEditingController nameController =
        TextEditingController(text: initialItem?.name ?? '');
    final TextEditingController imageController =
        TextEditingController(text: initialItem?.imageUrl ?? '');

    final isEditing = initialItem != null;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isEditing ? Icons.edit_note_rounded : Icons.add_photo_alternate_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(isEditing ? "تعديل النكهة والصورة" : "إضافة نكهة جديدة مع صورة"),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: !isEditing,
                    decoration: const InputDecoration(
                      hintText: "مثلاً: Pistachio أو فستق",
                      labelText: "اسم النكهة",
                      prefixIcon: Icon(Icons.icecream_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(
                      hintText: "https://example.com/flavor.jpg",
                      labelText: "رابط صورة النكهة (URL)",
                      prefixIcon: const Icon(Icons.link_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => imageController.clear(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "معاينة صورة النكهة:",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: imageController,
                    builder: (context, value, _) {
                      final url = value.text.trim();
                      if (url.isEmpty) {
                        return Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outlineVariant),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "ستظهر المعاينة هنا فور إدخال رابط الصورة",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, _, _) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_rounded,
                                    size: 28,
                                    color: colorScheme.error,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "تعذر تحميل الصورة، تحقق من الرابط",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                final newName = nameController.text.trim();
                final newImageUrl = imageController.text.trim();

                if (newName.isEmpty) return;

                final newItem = FlavorItem(
                  name: newName,
                  imageUrl: newImageUrl.isNotEmpty ? newImageUrl : null,
                );

                final updatedList = List<String>.from(selectedFlavors);

                // إزالة أي نكهة سابقة بنفس الاسم لتحديثها بالقيمة الجديدة
                updatedList.removeWhere(
                  (raw) =>
                      FlavorItem.fromRaw(raw).name.toLowerCase() ==
                      newName.toLowerCase(),
                );

                updatedList.add(newItem.rawValue);
                onSelectionChanged(updatedList);

                Navigator.pop(context);
              },
              child: Text(isEditing ? "حفظ التعديل" : "إضافة"),
            ),
          ],
        );
      },
    );
  }
}
