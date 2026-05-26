import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseFormIntro extends StatelessWidget {
  const ExpenseFormIntro({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing
              ? LocaleKeys.expenses_form_intro_editTitle.tr()
              : LocaleKeys.expenses_form_intro_addTitle.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8.h),
        Text(
          LocaleKeys.expenses_form_intro_description.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
