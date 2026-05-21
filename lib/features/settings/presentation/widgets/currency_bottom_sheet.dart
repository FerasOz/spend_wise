import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';

void showCurrencyBottomSheet(BuildContext context) {
  const currencies = [
    {'code': 'USD', 'symbol': '\$'},
    {'code': 'EUR', 'symbol': '€'},
    {'code': 'GBP', 'symbol': '£'},
    {'code': 'JPY', 'symbol': '¥'},
    {'code': 'INR', 'symbol': '₹'},
    {'code': 'AED', 'symbol': 'د.إ'},
    {'code': 'CAD', 'symbol': 'C\$'},
    {'code': 'AUD', 'symbol': 'A\$'},
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => SafeArea(
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BuildBottomSheetHeader(
              title: 'Select Currency',
              context: context,
            ),
            SizedBox(height: 24.h),
            ...currencies.map((currency) => _BuildCurrencyTile(
                  currency: currency,
                  context: context,
                )).toList(),
          ],
        ),
      ),
    ),
  );
}

Widget _BuildCurrencyTile({
  required Map<String, String> currency,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return ListTile(
    leading: Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        currency['symbol']!,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    ),
    title: Text(currency['code']!, style: theme.textTheme.bodyLarge),
    onTap: () {
      final currencyObj = AppCurrency(
        code: currency['code']!,
        symbol: currency['symbol']!,
      );
      context.read<SettingsCubit>().updateCurrency(currencyObj);
      Navigator.pop(context);
    },
  );
}

Widget _BuildBottomSheetHeader({
  required String title,
  required BuildContext context,
}) {
  return Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}