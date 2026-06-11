import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/features/recurring/presentation/extensions/recurring_repeat_type_extension.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../domain/entities/recurring_expense.dart';

class RecurringExpenseRepeatSection extends StatelessWidget {
  const RecurringExpenseRepeatSection({
    required this.repeatType,
    required this.onRepeatTypeChanged,
    super.key,
  });

  final ValueNotifier<RecurringRepeatType> repeatType;
  final ValueChanged<RecurringRepeatType> onRepeatTypeChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RecurringRepeatType>(
      valueListenable: repeatType,
      builder: (context, currentRepeatType, _) {
        return DropdownButtonFormField<RecurringRepeatType>(
          initialValue: currentRepeatType,
          decoration: InputDecoration(
            labelText: LocaleKeys.recurring_form_repeat.tr(),
          ),
          items: RecurringRepeatType.values
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item.localizedName),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value != null) {
              onRepeatTypeChanged(value);
            }
          },
        );
      },
    );
  }
}
