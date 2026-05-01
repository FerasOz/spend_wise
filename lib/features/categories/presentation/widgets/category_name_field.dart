import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';

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
