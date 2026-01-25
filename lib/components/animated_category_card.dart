import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/index.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  final int index;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    required this.index,
  });

  @override
  State<CategoryCard> createState() => CategoryCardState();
}

class CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {

  bool _isHovered = false;



  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _isHovered ? 0.08 : 0.03,
                ),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // صورة الخلفية
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.grey.shade200,
                ),
                child:
                    widget.category.imageUrl != null &&
                        widget.category.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          widget.category.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            child: const Icon(
                              Icons.category_outlined,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.category_outlined,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
              ),
              // الطبقة العلوية للنص
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // النص والمعلومات
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.category.isActive)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            'معطل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Expanded(child: Container()),
                    AnimatedOpacity(
                      opacity: _isHovered ? 1 : 0.95,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.category.description != null &&
                              widget.category.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.category.description!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // شريط الحركة الزخرفي
              if (_isHovered)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.5),
                          AppColors.primary,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
