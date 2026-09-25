import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'form_section_card.dart';

/// قسم معرض صور المنتج ورفعها بتصميم Neumorphism / Soft UI
class ProductMediaSection extends StatelessWidget {
  final ProductsController controller;
  final List<String> imageUrls;
  final ValueChanged<String> onAddImageUrl;
  final ValueChanged<int> onRemoveImage;
  final Function(int oldIdx, int newIdx) onReorderImage;

  const ProductMediaSection({
    super.key,
    required this.controller,
    required this.imageUrls,
    required this.onAddImageUrl,
    required this.onRemoveImage,
    required this.onReorderImage,
  });

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'معرض صور المنتج',
      subtitle: 'ارفع صور واضحة (الصورة الأولى هي صورة الغلاف)',
      icon: Icons.photo_library_outlined,
      trailing: TextButton.icon(
        onPressed: () => _showAddUrlDialog(context),
        icon: const Icon(Icons.link_rounded, size: 18),
        label: const Text('رابط URL'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrls.isEmpty)
            _buildEmptyUploadZone(context)
          else
            Column(
              children: [
                SizedBox(
                  height: 155,
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length + 1,
                    onReorderItem: (oldIdx, newIdx) {
                      if (oldIdx < imageUrls.length &&
                          newIdx <= imageUrls.length) {
                        onReorderImage(oldIdx, newIdx);
                      }
                    },
                    itemBuilder: (context, index) {
                      if (index == imageUrls.length) {
                        return Container(
                          key: const ValueKey('add_button'),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: _buildAddCard(context),
                        );
                      }

                      final url = imageUrls[index];
                      final isCover = index == 0;
                      final theme = Theme.of(context);
                      final colorScheme = theme.colorScheme;
                      final isDark = theme.brightness == Brightness.dark;

                      return Container(
                        key: ValueKey('img_${url}_$index'),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    Color.lerp(colorScheme.surfaceContainerHigh,
                                        Colors.white, 0.02)!,
                                    Color.lerp(colorScheme.surfaceContainerHigh,
                                        Colors.black, 0.12)!,
                                  ]
                                : [
                                    Colors.white,
                                    Color.lerp(colorScheme.surfaceContainerLow,
                                        Colors.black, 0.03)!,
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.35)
                                  : const Color(0xFFA3B1C6)
                                      .withValues(alpha: 0.35),
                              offset: const Offset(2, 2.5),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.02)
                                  : Colors.white.withValues(alpha: 0.90),
                              offset: const Offset(-1.5, -1.5),
                              blurRadius: 3,
                            ),
                          ],
                          border: Border.all(
                            color: isCover
                                ? colorScheme.primary
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.03)
                                    : Colors.white.withValues(alpha: 0.85)),
                            width: isCover ? 2.0 : 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              !url.startsWith('http')
                                  ? Image.file(File(url), fit: BoxFit.cover)
                                  : CachedNetworkImage(
                                      imageUrl: url,
                                      fit: BoxFit.cover,
                                      placeholder: (_, _) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (_, _, _) => const Center(
                                        child: Icon(Icons.broken_image_rounded),
                                      ),
                                    ),

                              // Cover Badge
                              if (isCover)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'الغلاف',
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                              // Delete Button
                              Positioned(
                                top: 6,
                                right: 6,
                                child: IconButton.filledTonal(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black54,
                                    foregroundColor: Colors.white,
                                  ),
                                  iconSize: 16,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => onRemoveImage(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '💡 يمكنك سحب الصور لإعادة ترتيبها وتحديد صورة الغلاف.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyUploadZone(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.12)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
            offset: const Offset(2, 2.5),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.45),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _pickAndUpload(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.20),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'انقر هنا لرفع صور المنتج من جهازك',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PNG, JPG حتى 5 ميجابايت',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.10)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
            offset: const Offset(1.5, 2),
            blurRadius: 3,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 2.5,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _pickAndUpload(context),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, size: 28),
              SizedBox(height: 8),
              Text('إضافة صورة', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(BuildContext context) async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    Get.showOverlay(
      asyncFunction: () async {
        final url = await controller.uploadImage(image.path);
        if (url != null) onAddImageUrl(url);
      },
      loadingWidget: const Center(child: CircularProgressIndicator()),
    );
  }

  void _showAddUrlDialog(BuildContext context) {
    final textCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة رابط صورة خارجي'),
        content: TextField(
          controller: textCtrl,
          decoration: const InputDecoration(
            hintText: 'https://example.com/image.jpg',
            prefixIcon: Icon(Icons.link),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                onAddImageUrl(textCtrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة الصورة'),
          ),
        ],
      ),
    );
  }
}
