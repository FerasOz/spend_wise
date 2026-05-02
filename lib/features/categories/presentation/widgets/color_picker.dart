import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class ColorPicker extends StatelessWidget {
  final int selectedColor;
  final void Function(int color) onColorSelected;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
          ),
          itemCount: CategoryPresentationData.colorPalette.length,
          itemBuilder: (context, index) {
            final colorValue = CategoryPresentationData.colorPalette[index];
            final color = Color(colorValue);
            final isSelected = selectedColor == colorValue;

            return GestureDetector(
              onTap: () {
                onColorSelected(colorValue);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3.w)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withAlpha((0.5 * 255).round()),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
