// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';

class ImageGalleryEditor extends StatelessWidget {
  final List<String> imageUrls;
  final Function(String) onAddUrl;
  final Function(int) onRemove;
  final VoidCallback onPickImage;

  const ImageGalleryEditor({
    super.key,
    required this.imageUrls,
    required this.onAddUrl,
    required this.onRemove,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'صور المنتج',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: () => _showAddUrlDialog(context),
              icon: const Icon(Icons.link, size: 18),
              label: const Text('إضافة رابط'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length + 1,
            itemBuilder: (context, index) {
              if (index == imageUrls.length) {
                return _buildAddButton(context, isDark);
              }
              return _buildImageItem(context, index, imageUrls[index], isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              'إضافة صورة',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(BuildContext context, int index, String url, bool isDark) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onRemove(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUrlDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة رابط صورة'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://example.com/image.jpg',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onAddUrl(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
