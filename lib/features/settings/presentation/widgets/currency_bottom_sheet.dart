import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';

void showCurrencyBottomSheet(BuildContext context) {
  const currencies = [
    AppCurrency(code: 'USD', symbol: '\$'),
    AppCurrency(code: 'EUR', symbol: '€'),
    AppCurrency(code: 'GBP', symbol: '£'),
    AppCurrency(code: 'JPY', symbol: '¥'),
    AppCurrency(code: 'INR', symbol: '₹'),
    AppCurrency(code: 'AED', symbol: 'د.إ'),
    AppCurrency(code: 'CAD', symbol: 'C\$'),
    AppCurrency(code: 'AUD', symbol: 'A\$'),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BuildBottomSheetHeader(title: 'Select Currency', context: context),
            SizedBox(height: 18.h),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final selectedCode = state.settings?.currency.code;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => Divider(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    height: 0,
                  ),
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected = selectedCode == currency.code;
                    return _BuildCurrencyTile(
                      currency: currency,
                      selected: isSelected,
                      context: context,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _BuildCurrencyTile({
  required AppCurrency currency,
  required bool selected,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 16.w,
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Text(
          currency.symbol,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(currency.code, style: theme.textTheme.bodyLarge),
      trailing: selected
          ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 22.sp,
            )
          : null,
      onTap: () {
        context.read<SettingsCubit>().updateCurrency(currency);
        Navigator.pop(context);
      },
    ),
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
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}
