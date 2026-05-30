import '../../features/settings/domain/entities/app_currency.dart';
import '../utils/currency_formatter.dart';

class CurrencyDisplayService {
  const CurrencyDisplayService._();

  static double convertFromUsd(double amount, AppCurrency currency) {
    // No conversion - return amount as-is
    return amount;
  }

  static String formatFromUsd(double amount, AppCurrency currency) {
    return CurrencyFormatter.format(
      amount, // Use original amount without conversion
      symbol: currency.symbol,
    );
  }
}
