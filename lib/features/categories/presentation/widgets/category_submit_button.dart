import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/base/requests_status.dart';

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
