import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/animated_category_card.dart';
import '../config/theme.dart';
import '../config/responsive.dart';
import '../models/index.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryModel> categories;
  final VoidCallback? onSeeAll;
  final Function(CategoryModel)? onCategoryTap;

  const CategoriesGrid({
    super.key,
    required this.categories,
    this.onSeeAll,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final crossAxisCount = responsive.getGridColumns();
    final spacing = responsive.itemSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left,
            vertical: responsive.defaultPadding.top / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التصنيفات',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.getTitleFontSize(),
                    ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: responsive.getBodyFontSize() - 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left,
            vertical: spacing / 2,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: responsive.getCardAspectRatio(),
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return AnimatedCategoryCard(
              category: category,
              index: index,
              onTap: () => onCategoryTap?.call(category),
            );
          },
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.backgroundLight),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            // صورة الخلفية
            if (category.imageUrl != null && category.imageUrl!.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl!),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.category_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            // الطبقة العلوية للنص
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            // النص
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!category.isActive)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(4),
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
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
