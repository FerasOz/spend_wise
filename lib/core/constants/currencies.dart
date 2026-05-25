import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../features/settings/domain/entities/app_currency.dart';

class SupportedCurrencyOption {
  const SupportedCurrencyOption({
    required this.currency,
    required this.name,
    required this.ratePerUsd,
  });

  final AppCurrency currency;
  final String name;
  final double ratePerUsd;
}

final supportedCurrencies = [
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'USD', symbol: '\$'),
    name: LocaleKeys.currency_names_USD.tr(),
    ratePerUsd: 1,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'EUR', symbol: '€'),
    name: LocaleKeys.currency_names_EUR.tr(),
    ratePerUsd: 0.92,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'ILS', symbol: '₪'),
    name: LocaleKeys.currency_names_ILS.tr(),
    ratePerUsd: 3.70,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'JOD', symbol: 'JD '),
    name: LocaleKeys.currency_names_JOD.tr(),
    ratePerUsd: 0.71,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'SAR', symbol: 'SAR '),
    name: LocaleKeys.currency_names_SAR.tr(),
    ratePerUsd: 3.75,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'GBP', symbol: '£'),
    name: LocaleKeys.currency_names_GBP.tr(),
    ratePerUsd: 0.78,
  ),
];

final currencySymbols = {
  for (final option in supportedCurrencies)
    option.currency.code: option.currency.symbol,
};

final kExchangeRatesPerUsd = {
  for (final option in supportedCurrencies)
    option.currency.code: option.ratePerUsd,
};

bool isSupportedCurrency(String code) =>
    currencySymbols.containsKey(code.toUpperCase());

SupportedCurrencyOption currencyOptionByCode(String code) {
  final normalizedCode = code.toUpperCase();
  return supportedCurrencies.firstWhere(
    (option) => option.currency.code == normalizedCode,
    orElse: () => supportedCurrencies.first,
  );
}

AppCurrency currencyByCode(String code) {
  return currencyOptionByCode(code).currency;
}

String currencyLabel(AppCurrency currency) {
  final option = currencyOptionByCode(currency.code);
  return '${option.currency.code} · ${option.name}';
}
