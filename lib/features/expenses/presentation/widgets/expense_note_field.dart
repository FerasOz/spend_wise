import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseNoteField extends StatelessWidget {
  const ExpenseNoteField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String? initialValue;
  final ValueChanged<String?> onSaved;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.9),
      child: TextFormField(
        key: ValueKey(
          initialValue?.isEmpty ?? true ? 'note' : 'note_$initialValue',
        ),
        initialValue: initialValue ?? '',
        decoration: InputDecoration(
          labelText: LocaleKeys.expenses_form_fields_note.tr(),
          hintText: LocaleKeys.expenses_form_fields_notePlaceholder.tr(),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSpacing.md.h,
            horizontal: AppSpacing.lg.w,
          ),
        ),
        minLines: 3,
        maxLines: 5,
        onSaved: onSaved,
      ),
    );
  }
}
