import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';

/// أدوات ومساعدات معالجة شجرة الأقسام (تسطيح، بحث، ومسار الفتات)
/// فئة مساعدة نقية تتبع مبدأ المسؤولية الواحدة (SRP)
class CategoryTreeUtils {
  const CategoryTreeUtils._();

  /// إيجاد مسار الفتات (Breadcrumbs) للتصنيف المحدد بالمعرّف
  static List<String> findBreadcrumbs(List<CategoryEntity> list, String targetId) {
    for (final cat in list) {
      if (cat.id == targetId) {
        return [cat.displayName];
      }
      if (cat.children.isNotEmpty) {
        final sub = findBreadcrumbs(cat.children, targetId);
        if (sub.isNotEmpty) {
          return [cat.displayName, ...sub];
        }
      }
    }
    return [];
  }

  /// تسطيح الشجرة الهرمية إلى قائمة أحادية للبحث السريع
  static List<CategoryEntity> flatten(List<CategoryEntity> list) {
    final result = <CategoryEntity>[];
    for (final cat in list) {
      result.add(cat);
      if (cat.children.isNotEmpty) {
        result.addAll(flatten(cat.children));
      }
    }
    return result;
  }

  /// فتح وتوسيع جميع العُقد والآباء التي تحتوي على التصنيف المختار
  static bool expandAncestors(
    List<CategoryEntity> list,
    String? targetId,
    Set<String> expandedIds,
  ) {
    if (targetId == null || targetId.isEmpty) return false;
    for (final cat in list) {
      if (cat.id == targetId) return true;
      if (cat.children.isNotEmpty) {
        if (expandAncestors(cat.children, targetId, expandedIds)) {
          expandedIds.add(cat.id);
          return true;
        }
      }
    }
    return false;
  }
}
