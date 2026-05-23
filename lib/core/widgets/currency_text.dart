// Copyright 2026 SpendWise. All rights reserved.
// Widget to display an amount in the current app currency.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/currencies.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../services/currency_display_service.dart';

/// Displays a monetary amount in the current app currency.
/// The [amount] is expected to be in USD (the internal base currency).
class CurrencyText extends StatelessWidget {
  const CurrencyText({
    required this.amount,
    this.style,
    this.prefix = '',
    this.suffix = '',
    super.key,
  });

  final double amount;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final currency = context.select(
      (SettingsCubit cubit) =>
          cubit.state.settings?.currency ?? currencyByCode('USD'),
    );

    return Text(
      '$prefix${CurrencyDisplayService.formatFromUsd(amount, currency)}$suffix',
      style: style,
    );
  }
}