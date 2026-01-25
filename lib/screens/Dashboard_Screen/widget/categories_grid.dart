import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/category_card.dart';
import '../../../config/theme.dart';
import '../../../config/responsive.dart';
import '../../../models/index.dart';

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
            return CategoryCard(
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
