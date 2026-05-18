import 'package:flutter/material.dart';

import '../../domain/entities/recurring_expense.dart';

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
          decoration: const InputDecoration(labelText: 'Repeat'),
          items: RecurringRepeatType.values
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item.name),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value != null) onRepeatTypeChanged(value);
          },
        );
      },
    );
  }
}
