import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/utils/app_formatters.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseDatePicker extends StatelessWidget {
  const ExpenseDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(12.r),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: LocaleKeys.expenses_form_fields_date.tr(),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        child: Text(
          AppFormatters.shortDate(selectedDate),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }
}
