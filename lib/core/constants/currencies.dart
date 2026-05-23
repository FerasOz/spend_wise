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

const supportedCurrencies = [
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'USD', symbol: '\$'),
    name: 'US Dollar',
    ratePerUsd: 1,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'EUR', symbol: '€'),
    name: 'Euro',
    ratePerUsd: 0.92,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'ILS', symbol: '₪'),
    name: 'Israeli Shekel',
    ratePerUsd: 3.70,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'JOD', symbol: 'JD '),
    name: 'Jordanian Dinar',
    ratePerUsd: 0.71,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'SAR', symbol: 'SAR '),
    name: 'Saudi Riyal',
    ratePerUsd: 3.75,
  ),
  SupportedCurrencyOption(
    currency: AppCurrency(code: 'GBP', symbol: '£'),
    name: 'British Pound',
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

bool isSupportedCurrency(String code) => currencySymbols.containsKey(code.toUpperCase());

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
