import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_draft_entity.dart';
import '../controllers/products_controller.dart';

/// نافذة منبثقة تفاعلية لعرض واستعادة وإدارة المسودات المحفوظة محلياً
class ProductDraftsDialog extends StatelessWidget {
  final ProductsController controller;
  final VoidCallback? onDraftRestored;

  const ProductDraftsDialog({
    super.key,
    required this.controller,
    this.onDraftRestored,
  });

  static Future<void> show({
    required BuildContext context,
    required ProductsController controller,
    VoidCallback? onDraftRestored,
  }) async {
    await controller.loadDrafts();
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => ProductDraftsDialog(
        controller: controller,
        onDraftRestored: onDraftRestored,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    }
    return DateFormat('yyyy/MM/dd - hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final count = controller.drafts.length;
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(
                            alpha: isDark ? 0.2 : 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.drafts_rounded,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'المسودات المحفوظة',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'يمكنك استعادة أي مسودة لمتابعة إكمالها أو حذفها',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: 'إغلاق',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Drafts List
              Expanded(
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    if (controller.isLoadingDrafts) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.drafts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 48,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد مسودات محفوظة حالياً',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'يمكنك حفظ أي نموذج غير مكتمل كمسودة بالضغط على "حفظ كمسودة" في صفحة المنتج',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: controller.drafts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final draft = controller.drafts[index];
                        final isCurrentActive =
                            controller.activeDraftId == draft.id;

                        return _buildDraftCard(
                          context,
                          theme,
                          colorScheme,
                          isDark,
                          draft,
                          isCurrentActive,
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('إغلاق النافذة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraftCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    ProductDraftEntity draft,
    bool isCurrentActive,
  ) {
    final priceStr = draft.formFields['price'];
    final brandStr = draft.formFields['brand'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentActive
            ? colorScheme.primaryContainer.withValues(alpha: isDark ? 0.3 : 0.4)
            : (isDark
                ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
                : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentActive
              ? colorScheme.primary.withValues(alpha: 0.6)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : colorScheme.outlineVariant.withValues(alpha: 0.4)),
          width: isCurrentActive ? 1.5 : 1.0,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            draft.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'المسودة الحالية',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(draft.updatedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (brandStr != null && brandStr.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Icon(
                            Icons.verified_outlined,
                            size: 13,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            brandStr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
                tooltip: 'حذف المسودة',
                onPressed: () => _confirmDelete(context, draft),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Metadata Chips & Actions
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (priceStr != null && priceStr.isNotEmpty)
                      _buildChip(
                        colorScheme,
                        icon: Icons.payments_outlined,
                        label: '$priceStr د.ع',
                      ),
                    if (draft.imageUrls.isNotEmpty)
                      _buildChip(
                        colorScheme,
                        icon: Icons.image_outlined,
                        label: '${draft.imageUrls.length} صور',
                      ),
                    if (draft.productSizes.isNotEmpty)
                      _buildChip(
                        colorScheme,
                        icon: Icons.straighten_rounded,
                        label: '${draft.productSizes.length} أحجام',
                      ),
                    if (draft.productFlavors.isNotEmpty)
                      _buildChip(
                        colorScheme,
                        icon: Icons.icecream_outlined,
                        label: '${draft.productFlavors.length} نكهات',
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  controller.restoreDraft(draft);
                  Navigator.of(context).pop();
                  onDraftRestored?.call();
                },
                icon: const Icon(Icons.edit_note_rounded, size: 16),
                label: const Text('استعادة وتحرير'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    ColorScheme colorScheme, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductDraftEntity draft) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المسودة'),
        content: Text('هل أنت متأكد من حذف مسودة "${draft.title}" نهائياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.removeDraft(draft.id);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
