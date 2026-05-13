import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class IconPicker extends StatelessWidget {
  final String selectedIcon;
  final void Function(String icon) onIconSelected;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Icon',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSpacing.md.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: AppSpacing.sm.h,
            crossAxisSpacing: 8.w,
          ),
          itemCount: CategoryPresentationData.iconNames.length,
          itemBuilder: (context, index) {
            final iconName = CategoryPresentationData.iconNames[index];
            final isSelected = selectedIcon == iconName;

            return GestureDetector(
              onTap: () {
                onIconSelected(iconName);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).primaryColor.withAlpha((0.2 * 255).round())
                      : Colors.grey.withAlpha((0.1 * 255).round()),
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2.w,
                        )
                      : null,
                ),
                child: Icon(
                  CategoryPresentationData.iconFor(iconName),
                  size: 28.sp,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
