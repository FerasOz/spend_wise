import '../../features/settings/domain/entities/app_currency.dart';
import '../utils/currency_formatter.dart';

class CurrencyDisplayService {
  const CurrencyDisplayService._();

  static const Map<String, double> _usdRates = {
    'USD': 1,
    'EUR': .92,
    'ILS': 3.65,
    'JOD': .71,
    'SAR': 3.75,
  };

  static double convertFromUsd(double amount, AppCurrency currency) {
    final rate = _usdRates[currency.code.toUpperCase()] ?? 1;
    return amount * rate;
  }

  static String formatFromUsd(double amount, AppCurrency currency) {
    return CurrencyFormatter.format(
      convertFromUsd(amount, currency),
      symbol: currency.symbol,
    );
  }
}
