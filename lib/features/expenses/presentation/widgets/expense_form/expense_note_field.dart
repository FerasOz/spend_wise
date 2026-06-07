import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseNoteField extends StatefulWidget {
  const ExpenseNoteField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String? initialValue;
  final ValueChanged<String?> onSaved;

  @override
  State<ExpenseNoteField> createState() => _ExpenseNoteFieldState();
}

class _ExpenseNoteFieldState extends State<ExpenseNoteField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(0.9),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: TextFormField(
          focusNode: _focusNode,
          key: ValueKey(
            widget.initialValue?.isEmpty ?? true ? 'note' : 'note_${widget.initialValue}',
          ),
          initialValue: widget.initialValue ?? '',
          decoration: InputDecoration(
            labelText: LocaleKeys.expenses_form_fields_note.tr(),
            hintText: LocaleKeys.expenses_form_fields_notePlaceholder.tr(),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSpacing.md.h,
              horizontal: AppSpacing.lg.w,
            ),
            border: InputBorder.none,
          ),
          minLines: 3,
          maxLines: 5,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
