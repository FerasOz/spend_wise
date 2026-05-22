import '../constants/exchange_rates.dart';

class CurrencyConverter {
  const CurrencyConverter._();

  static double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    final fromRate = kExchangeRatesPerUsd[from.toUpperCase()] ?? 1.0;
    final toRate = kExchangeRatesPerUsd[to.toUpperCase()] ?? 1.0;

    if (from.toUpperCase() == to.toUpperCase()) return amount;

    final result = amount * (toRate / fromRate);
    return result;
  }
}
