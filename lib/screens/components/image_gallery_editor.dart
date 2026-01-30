import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import '../../config/theme.dart';

class ImageGalleryEditor extends StatelessWidget {
  final List<String> imageUrls;
  final Function(String) onAddUrl;
  final Function(int) onRemove;
  final VoidCallback onPickImage;
  
  final Function(int oldIndex, int newIndex) onReorder;

  const ImageGalleryEditor({
    super.key,
    required this.imageUrls,
    required this.onAddUrl,
    required this.onRemove,
    required this.onPickImage,
    required this.onReorder, 
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
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddUrlDialog(context),
              icon: const Icon(color: AppColors.info, Icons.link, size: 18),
              label: const Text(
                style: TextStyle(color: AppColors.info),
                'إضافة رابط صورة',
              ),
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
              return Material(color: Colors.transparent, child: child);
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
                key: ValueKey(
                  imageUrls[index] + index.toString(),
                ), // مفتاح فريد لكل صورة
              );
            },
          ),
        ),
      ],
    );
  }

  // أضفنا Key هنا ليعمل الـ Reorderable بشكل صحيح
Widget _buildImageItem(
  BuildContext context,
  int index,
  String url,
  bool isDark, {
  required Key key,
}) {
  return Container(
    key: key,
    width: 130,
    height: 150, // تحديد الارتفاع لضمان التناسق
    margin: const EdgeInsets.only(left: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16), // حواف أنعم
      border: Border.all(color: isDark ? Colors.white10 : Colors.black12 ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand, // لجعل الصورة تأخذ كامل المساحة
        children: [
          // عرض الصورة مع معالجة حالة التحميل والخطأ
          CachedNetworkImage(
           imageUrl:  url,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
          ),

          // طبقة تعتيم خفيفة لإبراز الأيقونات
          Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.2))),

          // أيقونة السحب (أصبحت أكثر أناقة)
          const Center(
            child: Icon(Icons.drag_indicator_rounded, color: Colors.white, size: 28),
          ),

          // زر الحذف المحسن
          Positioned(
            top: 6,
            right: 6,
            child: Material( // إضافة Material لإظهار تأثير اللمس (Ripple Effect)
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onRemove(index),
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.9), // لون أحمر يعطي انطباع الحذف
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // باقي الكود (_buildAddButton و _showAddUrlDialog) يبقى كما هو...

  Widget _buildAddButton(BuildContext context, bool isDark) {
    return GlassContainer(
      onTap: onPickImage ,
      padding: EdgeInsets.all(12),
      width: 100,
      margin: const EdgeInsets.only(left: 19),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            'إضافة صورة',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
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
