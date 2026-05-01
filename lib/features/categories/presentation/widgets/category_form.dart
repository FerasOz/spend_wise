import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_cubit.dart';
import 'package:spend_wise/features/categories/presentation/cubit/category_state.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_name_field.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_preview_card.dart';
import 'package:spend_wise/features/categories/presentation/widgets/category_submit_button.dart';
import 'package:spend_wise/features/categories/presentation/widgets/color_picker.dart';
import 'package:spend_wise/features/categories/presentation/widgets/icon_picker.dart';

class CategoryForm extends StatelessWidget {
  CategoryForm({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) {
        return previous.categoryName != current.categoryName ||
            previous.selectedIcon != current.selectedIcon ||
            previous.selectedColor != current.selectedColor ||
            previous.submissionStatus != current.submissionStatus ||
            previous.formVersion != current.formVersion ||
            previous.editingCategory != current.editingCategory;
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryPreviewCard(state: state),
                  SizedBox(height: 32.h),
                  CategoryNameField(
                    formVersion: state.formVersion,
                    initialValue: state.categoryName,
                  ),
                  SizedBox(height: 24.h),
                  IconPicker(
                    selectedIcon: state.selectedIcon,
                    onIconSelected: context.read<CategoryCubit>().selectIcon,
                  ),
                  SizedBox(height: 24.h),
                  ColorPicker(
                    selectedColor: state.selectedColor,
                    onColorSelected: context.read<CategoryCubit>().selectColor,
                  ),
                  SizedBox(height: 32.h),
                  CategorySubmitButton(
                    isEditing: state.isEditing,
                    submissionStatus: state.submissionStatus,
                    onPressed: () => _submit(context),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    context.read<CategoryCubit>().submitCategory();
  }
}
