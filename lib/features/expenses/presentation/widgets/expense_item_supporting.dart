import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/currency_converter.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../domain/entities/expense.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';

class ExpenseLeadingAccent extends StatelessWidget {
  const ExpenseLeadingAccent({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class ExpenseHeader extends StatelessWidget {
  const ExpenseHeader({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);

    final displayCurrency = context.select(
      (SettingsCubit cubit) =>
          cubit.state.settings?.currency ??
          (throw StateError('Settings not loaded')),
    );

    final converted = CurrencyConverter.convert(
      amount: expense.amount,
      from: 'USD',
      to: displayCurrency.code,
    );

    final formatted = CurrencyFormatter.format(
      converted,
      symbol: displayCurrency.symbol,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(expense.title, style: textStyle)),
        SizedBox(width: 10.w),
        Text(formatted, style: textStyle),
      ],
    );
  }
}

class ExpenseDateLabel extends StatelessWidget {
  const ExpenseDateLabel({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 6.w),
        Text(
          AppFormatters.shortDate(date),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
