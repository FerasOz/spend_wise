import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../features/settings/domain/entities/app_currency.dart';

class SupportedCurrencyOption {
  const SupportedCurrencyOption({
    required this.currency,
    required this.translationKey,
  });

  final AppCurrency currency;
  final String translationKey;
}

const supportedCurrencies = [
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'USD', symbol: r'$'),
    translationKey: LocaleKeys.currency_names_USD,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'EUR', symbol: '€'),
    translationKey: LocaleKeys.currency_names_EUR,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'ILS', symbol: '₪'),
    translationKey: LocaleKeys.currency_names_ILS,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'JOD', symbol: 'JD '),
    translationKey: LocaleKeys.currency_names_JOD,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'SAR', symbol: 'SAR '),
    translationKey: LocaleKeys.currency_names_SAR,
  ),
];

final currencySymbols = {
  for (final option in supportedCurrencies)
    option.currency.code: option.currency.symbol,
};

bool isSupportedCurrency(String code) {
  return currencySymbols.containsKey(code.toUpperCase());
}

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
  return '${option.currency.code} · ${option.translationKey.tr()}';
}
