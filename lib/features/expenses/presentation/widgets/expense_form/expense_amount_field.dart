import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseAmountField extends StatefulWidget {
  const ExpenseAmountField({
    required this.initialValue,
    required this.onSaved,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String?> onSaved;

  @override
  State<ExpenseAmountField> createState() => _ExpenseAmountFieldState();
}

class _ExpenseAmountFieldState extends State<ExpenseAmountField> {
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
          key: ValueKey(widget.initialValue.isEmpty ? 'amount' : 'amount_${widget.initialValue}'),
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            labelText: LocaleKeys.expenses_form_fields_amount.tr(),
            hintText: '24.99',
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSpacing.md.h,
              horizontal: AppSpacing.lg.w,
            ),
            border: InputBorder.none,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          textInputAction: TextInputAction.next,
          validator: (value) {
            final parsed = double.tryParse(value?.trim() ?? '');
            if (parsed == null || parsed <= 0) {
              return LocaleKeys.expenses_form_fields_validAmount.tr();
            }
            return null;
          },
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
