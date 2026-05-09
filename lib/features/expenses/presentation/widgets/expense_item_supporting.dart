import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/expense.dart';

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
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(expense.title, style: textStyle)),
        SizedBox(width: 10.w),
        Text('\$${expense.amount.toStringAsFixed(2)}', style: textStyle),
      ],
    );
  }
}

class ExpenseDateLabel extends StatelessWidget {
  const ExpenseDateLabel({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14.sp,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 6.w),
        Text(
          '$day/$month/${date.year}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
