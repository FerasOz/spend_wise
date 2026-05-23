import '../../features/settings/domain/entities/app_currency.dart';
import '../utils/currency_formatter.dart';
import 'currency_converter.dart';

class CurrencyDisplayService {
  const CurrencyDisplayService._();

  static double convertFromUsd(double amount, AppCurrency currency) {
    return CurrencyConverter.convert(
      amount: amount,
      from: 'USD',
      to: currency.code,
    );
  }

  static String formatFromUsd(double amount, AppCurrency currency) {
    return CurrencyFormatter.format(
      convertFromUsd(amount, currency),
      symbol: currency.symbol,
    );
  }
}
