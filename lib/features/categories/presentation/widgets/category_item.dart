import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_colors.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_expense_summary.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.category,
    required this.summary,
    required this.onTap,
    required this.onEdit,
    this.onDelete,
    super.key,
  });

  final Category category;
  final CategoryExpenseSummary summary;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(category.color);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.97, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.scale(scale: value, child: child),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.sm.h,
        ),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.xxl.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.xxl.r),
            child: Ink(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xxl.r),
                border: Border.all(color: color.withAlpha(36)),
                gradient: LinearGradient(
                  colors: [color.withAlpha(18), theme.colorScheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                    color: AppColors.shadow,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Hero(
                    tag: 'category-icon-${category.id}',
                    child: Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(AppRadius.xl.r),
                      ),
                      child: Icon(
                        CategoryPresentationData.iconFor(category.icon),
                        color: theme.colorScheme.onPrimary,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(child: _CategoryTextContent(category: category, summary: summary)),
                  _CategoryActions(
                    category: category,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTextContent extends StatelessWidget {
  const _CategoryTextContent({required this.category, required this.summary});

  final Category category;
  final CategoryExpenseSummary summary;

  @override
  Widget build(BuildContext context) {
    final spentLabel = '\$${summary.totalSpent.toStringAsFixed(2)} spent';
    final countLabel = '${summary.expenseCount} expenses';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (category.isDefault) ...[
              SizedBox(width: AppSpacing.sm.w),
              const _CategoryDefaultBadge(),
            ],
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          spentLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          countLabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CategoryActions extends StatelessWidget {
  const _CategoryActions({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Category actions',
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete?.call();
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        if (!category.isDefault && onDelete != null)
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
      icon: const Icon(Icons.more_horiz),
    );
  }
}

class _CategoryDefaultBadge extends StatelessWidget {
  const _CategoryDefaultBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'Default',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
