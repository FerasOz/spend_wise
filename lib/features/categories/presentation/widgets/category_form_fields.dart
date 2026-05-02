import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/utils/category_presentation_data.dart';

class CategoryNameField extends StatelessWidget {
  const CategoryNameField({
    required this.formVersion,
    required this.initialValue,
    super.key,
  });

  final int formVersion;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Name',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          key: ValueKey('category-name-$formVersion'),
          initialValue: initialValue,
          maxLength: 30,
          onChanged: context.read<CategoryCubit>().updateCategoryName,
          decoration: InputDecoration(
            hintText: 'Enter category name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            prefixIcon: const Icon(Icons.label),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Category name cannot be empty';
            }
            if (value.trim().length > 30) {
              return 'Category name cannot be longer than 30 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class CategoryPreviewCard extends StatelessWidget {
  const CategoryPreviewCard({required this.state, super.key});

  final CategoryState state;

  @override
  Widget build(BuildContext context) {
    final displayName = state.categoryName.trim().isEmpty
        ? 'New Category'
        : state.categoryName.trim();

    return Center(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Color(state.selectedColor),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              CategoryPresentationData.iconFor(state.selectedIcon),
              color: Colors.white,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 12.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              displayName,
              key: ValueKey(displayName),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySubmitButton extends StatelessWidget {
  const CategorySubmitButton({
    required this.isEditing,
    required this.submissionStatus,
    required this.onPressed,
    super.key,
  });

  final bool isEditing;
  final RequestsStatus submissionStatus;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: submissionStatus == RequestsStatus.loading
            ? null
            : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          submissionStatus == RequestsStatus.loading
              ? 'Saving...'
              : isEditing
              ? 'Update Category'
              : 'Add Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
