import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../../core/utils/app_formatters.dart';

class RecurringExpenseDueDateTile extends StatelessWidget {
  const RecurringExpenseDueDateTile({
    required this.date,
    required this.onDateChanged,
    super.key,
  });

  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(LocaleKeys.recurring_details_nextDueDate.tr()),
      subtitle: Text(AppFormatters.shortDate(date)),
      trailing: const Icon(Icons.calendar_today_outlined),
      onTap: () => _pickDate(context),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      onDateChanged(pickedDate);
    }
  }
}
