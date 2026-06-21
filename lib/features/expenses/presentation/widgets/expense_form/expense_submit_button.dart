import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

typedef SubmitExpenseCallback = Future<void> Function();

class ExpenseSubmitButton extends StatefulWidget {
  const ExpenseSubmitButton({
    required this.isEditing,
    required this.submissionStatus,
    required this.onSubmit,
    super.key,
  });

  final bool isEditing;
  final RequestsStatus submissionStatus;
  final SubmitExpenseCallback onSubmit;

  @override
  State<ExpenseSubmitButton> createState() => _ExpenseSubmitButtonState();
}

class _ExpenseSubmitButtonState extends State<ExpenseSubmitButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.submissionStatus != RequestsStatus.loading) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.submissionStatus != RequestsStatus.loading) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () {
        if (widget.submissionStatus != RequestsStatus.loading) {
          setState(() => _isPressed = false);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.diagonal3Values(
            _isPressed ? 0.98 : 1.0,
            _isPressed ? 0.98 : 1.0,
            1.0,
          ),
          child: FilledButton(
            onPressed: widget.submissionStatus == RequestsStatus.loading ? null : widget.onSubmit,
            child: Text(
              widget.submissionStatus == RequestsStatus.loading
                  ? LocaleKeys.categories_form_fields_saving.tr()
                  : widget.isEditing
                  ? LocaleKeys.expenses_buttons_update.tr()
                  : LocaleKeys.expenses_buttons_save.tr(),
            ),
          ),
        ),
      ),
    );
  }
}
