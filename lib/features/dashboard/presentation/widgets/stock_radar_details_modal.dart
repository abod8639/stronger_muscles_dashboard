import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import '../../domain/entities/ai_executive_briefing_entity.dart';

/// نافذة منبثقة تفاعلية تعرض تفاصيل رادار المخزون الذكي المدعوم بـ Gemini AI
class StockRadarDetailsModal extends StatefulWidget {
  final List<StockRadarAlertEntity> alerts;
  final List<ProductEntity> allProducts;

  const StockRadarDetailsModal({
    super.key,
    required this.alerts,
    this.allProducts = const [],
  });

  static Future<void> show({
    required BuildContext context,
    required List<StockRadarAlertEntity> alerts,
    List<ProductEntity> allProducts = const [],
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) => StockRadarDetailsModal(
        alerts: alerts,
        allProducts: allProducts,
      ),
    );
  }

  @override
  State<StockRadarDetailsModal> createState() => _StockRadarDetailsModalState();
}

class _StockRadarDetailsModalState extends State<StockRadarDetailsModal> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  List<StockRadarAlertEntity> get _filteredAlerts {
    return widget.alerts.where((alert) {
      if (_selectedFilter == 'out_of_stock' && !alert.isOutOfStock) {
        return false;
      }
      if (_selectedFilter == 'critical' && !alert.isCritical) {
        return false;
      }
      if (_selectedFilter == 'warning' && (alert.isOutOfStock || alert.isCritical)) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return alert.productName.toLowerCase().contains(query) ||
            (alert.categoryName?.toLowerCase().contains(query) ?? false);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final outOfStockCount = widget.alerts.where((a) => a.isOutOfStock).length;
    final criticalCount = widget.alerts.where((a) => a.isCritical).length;

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(
                        alpha: isDark ? 0.2 : 0.12,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.radar_rounded,
                      color: colorScheme.error,
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
                              'رادار المخزون الذكي (AI Stock Radar)',
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
                                color: colorScheme.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${widget.alerts.length} تنبيهات',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تنبؤات Gemini بالمنتجات المهددة بالنفاد وتوصيات إعادة الطلب العاجلة',
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
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'الكل (${widget.alerts.length})',
                      value: 'all',
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'نفد تماماً ($outOfStockCount)',
                      value: 'out_of_stock',
                      colorScheme: colorScheme,
                      badgeColor: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'مخزون حرج ($criticalCount)',
                      value: 'critical',
                      colorScheme: colorScheme,
                      badgeColor: colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'مخزون منخفض',
                      value: 'warning',
                      colorScheme: colorScheme,
                      badgeColor: Colors.amber.shade800,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Search Box
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'ابحث باسم المنتج أو القسم في الرادار...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),

              // Alerts List
              Expanded(
                child: _filteredAlerts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 48,
                              color: colorScheme.primary.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد تنبيهات مخزون مطابقة لهذا الفلتر',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredAlerts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final alert = _filteredAlerts[index];
                          return _buildAlertCard(
                            context,
                            theme,
                            colorScheme,
                            isDark,
                            alert,
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

  Widget _buildFilterChip({
    required String label,
    required String value,
    required ColorScheme colorScheme,
    Color? badgeColor,
  }) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = value),
      selectedColor: (badgeColor ?? colorScheme.primary).withValues(alpha: 0.18),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected
            ? (badgeColor ?? colorScheme.primary)
            : colorScheme.onSurfaceVariant,
      ),
      side: BorderSide(
        color: isSelected
            ? (badgeColor ?? colorScheme.primary).withValues(alpha: 0.6)
            : colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    StockRadarAlertEntity alert,
  ) {
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (alert.isOutOfStock) {
      statusColor = Colors.red.shade900;
      statusLabel = 'نفد تماماً (0)';
      statusIcon = Icons.cancel_rounded;
    } else if (alert.isCritical) {
      statusColor = colorScheme.error;
      statusLabel = 'حرج جداً (${alert.currentStock})';
      statusIcon = Icons.warning_rounded;
    } else {
      statusColor = Colors.amber.shade800;
      statusLabel = 'منخفض (${alert.currentStock})';
      statusIcon = Icons.info_outline_rounded;
    }

    // Try finding the actual ProductEntity to navigate to form
    ProductEntity? matchedProduct;
    try {
      matchedProduct = widget.allProducts.firstWhere(
        (p) => p.id == alert.productId || p.displayName == alert.productName,
      );
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.4)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: statusColor.withValues(alpha: isDark ? 0.3 : 0.25),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.productName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        alert.suggestedAction,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (matchedProduct != null) ...[
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.edit_note_rounded),
              tooltip: 'تعديل المنتج والمخزون',
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.productForm, extra: matchedProduct);
              },
            ),
          ],
        ],
      ),
    );
  }
}

