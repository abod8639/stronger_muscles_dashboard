// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';

class ImageGalleryEditor extends StatelessWidget {
  final List<String> imageUrls;
  final Function(String) onAddUrl;
  final Function(int) onRemove;
  final VoidCallback onPickImage;
  // إضافة هذه الـ Function للتعامل مع إعادة الترتيب
  final Function(int oldIndex, int newIndex) onReorder; 

  const ImageGalleryEditor({
    super.key,
    required this.imageUrls,
    required this.onAddUrl,
    required this.onRemove,
    required this.onPickImage,
    required this.onReorder, // مررها هنا
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
              style: TextStyle(
                // color: AppColors.info,
                fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: () => _showAddUrlDialog(context),
              icon: const Icon(
                color: AppColors.info,
                Icons.link, size: 18),
              label: const Text(
                style: TextStyle(
                  color: AppColors.info,
                ),
                'إضافة رابط صورة'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 120,
          // استخدام ReorderableListView بدلاً من ListView العادي
          child: ReorderableListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length + 1,
            onReorder: (oldIndex, newIndex) {
              // نمنع سحب زر "إضافة صورة"
              if (oldIndex < imageUrls.length && newIndex <= imageUrls.length) {
                onReorder(oldIndex, newIndex);
              }
            },
            proxyDecorator: (child, index, animation) {
              // تحسين شكل العنصر أثناء السحب
              return Material(
                color: Colors.transparent,
                child: child,
              );
            },
            itemBuilder: (context, index) {
              // زر الإضافة (دائماً في الأخير)
              if (index == imageUrls.length) {
                return Container(
                  key: const ValueKey('add_button'), // مفتاح ثابت
                  child: _buildAddButton(context, isDark),
                );
              }
              
              // عنصر الصورة
              return _buildImageItem(
                context, 
                index, 
                imageUrls[index], 
                isDark,
                key: ValueKey(imageUrls[index] + index.toString()), // مفتاح فريد لكل صورة
              );
            },
          ),
        ),
      ],
    );
  }

  // أضفنا Key هنا ليعمل الـ Reorderable بشكل صحيح
  Widget _buildImageItem(BuildContext context, int index, String url, bool isDark, {required Key key}) {
    return Container(
      key: key, 
      width: 100,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: 
          NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // تلميح بصري: أيقونة للسحب (اختياري)
          const Align(
            alignment: Alignment.center,
            child: Icon(Icons.drag_indicator, color: Colors.white70),
          ),
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
  
  // باقي الكود (_buildAddButton و _showAddUrlDialog) يبقى كما هو...


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
