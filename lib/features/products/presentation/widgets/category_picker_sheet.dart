import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'القسم / التصنيف',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: colorScheme.error, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card.outlined(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: hasSelection
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant,
              width: hasSelection ? 1.5 : 1,
            ),
          ),
          color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _openPickerSheet(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasSelection
                          ? Icons.folder_special_rounded
                          : Icons.folder_open_rounded,
                      color: hasSelection
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      size: 20,
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
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                    fontWeight: i == breadcrumbs.length - 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (i < breadcrumbs.length - 1)
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    size: 16,
                                    color: colorScheme.outline,
                                  ),
                              ],
                            ],
                          )
                        : Text(
                            'اختر قسم المنتج من القائمة...',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                              fontSize: 13,
                            ),
                          ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => _openPickerSheet(context),
                    icon: const Icon(Icons.unfold_more_rounded, size: 16),
                    label: Text(hasSelection ? 'تغيير' : 'اختيار'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
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
      showDragHandle: true,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSearching = _searchQuery.trim().isNotEmpty;
    final flatList = isSearching ? _flatten(widget.categories) : [];
    final searchResults = isSearching
        ? flatList
            .where((c) =>
                c.displayName.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList()
        : [];

    return SizedBox(
      height: media.size.height * 0.85,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_tree_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'اختيار تصنيف المنتج',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),

          // M3 SearchBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar(
              hintText: 'ابحث عن قسم بالاسم...',
              leading: const Icon(Icons.search_rounded),
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
              ),
              side: WidgetStatePropertyAll(
                BorderSide(color: colorScheme.outlineVariant),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (results.isEmpty) {
      return Center(
        child: Text(
          'لا توجد أقسام تطابق البحث',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
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
          selected: isSelected,
          selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.25),
          leading: Icon(
            isSelected ? Icons.check_circle_rounded : Icons.folder_outlined,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          title: Text(
            cat.displayName,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'محدد',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                ? colorScheme.primaryContainer.withValues(alpha: 0.2)
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
                        color: colorScheme.onSurfaceVariant,
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
                  size: 20,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cat.displayName,
                    style: TextStyle(
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  Text(
                    'محدد',
                    style: TextStyle(
                      color: colorScheme.primary,
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
