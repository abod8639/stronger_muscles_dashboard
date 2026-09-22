import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';

class CategoryPickerField extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const CategoryPickerField({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  List<String> _findBreadcrumbs(List<CategoryEntity> list, String targetId) {
    for (final cat in list) {
      if (cat.id == targetId) {
        return [cat.displayName];
      }
      if (cat.children.isNotEmpty) {
        final sub = _findBreadcrumbs(cat.children, targetId);
        if (sub.isNotEmpty) {
          return [cat.displayName, ...sub];
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = selectedId != null && selectedId!.isNotEmpty
        ? _findBreadcrumbs(categories, selectedId!)
        : <String>[];

    final hasSelection = breadcrumbs.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              size: 16,
              color: AppColors.primary.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
            const Text(
              'القسم / التصنيف',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openPickerSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasSelection
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.12),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasSelection
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    hasSelection
                        ? Icons.folder_special_rounded
                        : Icons.folder_open_rounded,
                    color: hasSelection ? AppColors.primary : Colors.white54,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: hasSelection
                      ? Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            for (int i = 0; i < breadcrumbs.length; i++) ...[
                              Text(
                                breadcrumbs[i],
                                style: TextStyle(
                                  color: i == breadcrumbs.length - 1
                                      ? Colors.white
                                      : Colors.white60,
                                  fontSize: 13,
                                  fontWeight: i == breadcrumbs.length - 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (i < breadcrumbs.length - 1)
                                const Icon(
                                  Icons.chevron_left_rounded,
                                  size: 16,
                                  color: Colors.white38,
                                ),
                            ],
                          ],
                        )
                      : const Text(
                          'اختر قسم المنتج من القائمة...',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hasSelection ? 'تغيير' : 'اختيار',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.unfold_more_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryPickerSheet(
        categories: categories,
        selectedId: selectedId,
        onSelected: onSelected,
      ),
    );
  }
}

class CategoryPickerSheet extends StatefulWidget {
  final List<CategoryEntity> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const CategoryPickerSheet({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  State<CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<CategoryPickerSheet> {
  String _searchQuery = '';
  final Set<String> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    _expandAncestors(widget.categories, widget.selectedId);
  }

  bool _expandAncestors(List<CategoryEntity> list, String? targetId) {
    if (targetId == null) return false;
    for (final cat in list) {
      if (cat.id == targetId) return true;
      if (cat.children.isNotEmpty) {
        if (_expandAncestors(cat.children, targetId)) {
          _expandedIds.add(cat.id);
          return true;
        }
      }
    }
    return false;
  }

  List<CategoryEntity> _flatten(List<CategoryEntity> list) {
    final result = <CategoryEntity>[];
    for (final cat in list) {
      result.add(cat);
      if (cat.children.isNotEmpty) {
        result.addAll(_flatten(cat.children));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isSearching = _searchQuery.trim().isNotEmpty;
    final flatList = isSearching ? _flatten(widget.categories) : [];
    final searchResults = isSearching
        ? flatList
            .where((c) =>
                c.displayName.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList()
        : [];

    return Container(
      height: media.size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColorsExtended.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_tree_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'اختيار تصنيف المنتج',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'ابحث عن قسم بالاسم...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white10),

          // Category List
          Expanded(
            child: isSearching
                ? _buildSearchResults(searchResults)
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: widget.categories
                        .map((c) => _buildTreeNode(c, 0))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد أقسام تطابق البحث',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final cat = results[i] as CategoryEntity;
        final isSelected = widget.selectedId == cat.id;

        return ListTile(
          onTap: () {
            widget.onSelected(cat.id);
            Navigator.pop(context);
          },
          leading: Icon(
            isSelected ? Icons.check_circle_rounded : Icons.folder_outlined,
            color: isSelected ? AppColors.primary : Colors.white54,
          ),
          title: Text(
            cat.displayName,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'محدد',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTreeNode(CategoryEntity cat, int depth) {
    final hasChildren = cat.children.isNotEmpty;
    final isSelected = widget.selectedId == cat.id;
    final isExpanded = _expandedIds.contains(cat.id);

    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.onSelected(cat.id);
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(
              right: 16.0 + (depth * 20.0),
              left: 16,
              top: 10,
              bottom: 10,
            ),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            child: Row(
              children: [
                if (hasChildren)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedIds.remove(cat.id);
                        } else {
                          _expandedIds.add(cat.id);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.chevron_left_rounded,
                        size: 20,
                        color: Colors.white54,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 28),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : (hasChildren
                          ? Icons.folder_rounded
                          : Icons.bookmark_border_rounded),
                  size: 18,
                  color: isSelected ? AppColors.primary : Colors.white54,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cat.displayName,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.white,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  const Text(
                    'محدد',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          for (final child in cat.children) _buildTreeNode(child, depth + 1),
      ],
    );
  }
}
