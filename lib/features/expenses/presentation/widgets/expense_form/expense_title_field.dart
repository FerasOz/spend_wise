import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseTitleField extends StatefulWidget {
  const ExpenseTitleField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String?> onSaved;

  @override
  State<ExpenseTitleField> createState() => _ExpenseTitleFieldState();
}

class _ExpenseTitleFieldState extends State<ExpenseTitleField> {
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
      opacity: const AlwaysStoppedAnimation(0.9),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: _focusNode.hasFocus
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: _focusNode.hasFocus ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(
          focusNode: _focusNode,
          key: ValueKey(widget.initialValue.isEmpty
              ? 'title'
              : 'title_${widget.initialValue}'),
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            labelText: LocaleKeys.expenses_form_fields_title.tr(),
            hintText: LocaleKeys.expenses_form_fields_titlePlaceholder.tr(),
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSpacing.md.h,
              horizontal: AppSpacing.lg.w,
            ),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return LocaleKeys.expenses_form_fields_titleRequired.tr();
            }
            return null;
          },
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}