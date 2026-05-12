import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseTextField extends StatelessWidget {
  const ExpenseTextField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefixText,
    this.minLines,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? prefixText;
  final int? minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyMedium,

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.lg.h,
        ),
      ),
    );
  }
}
