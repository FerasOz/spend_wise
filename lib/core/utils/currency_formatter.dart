class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(double amount, {String symbol = '\$'}) {
    final rounded = amount.toStringAsFixed(2);
    final parts = rounded.split('.');
    final integer = parts[0];
    final decimals = parts.length > 1 ? parts[1] : '00';

    final buffer = StringBuffer();
    for (var i = 0; i < integer.length; i++) {
      final pos = integer.length - i;
      buffer.write(integer[i]);
      final shouldSep = pos > 1 && pos % 3 == 1;
      if (shouldSep) buffer.write(',');
    }

    final withSep = buffer.toString();
    return '$symbol$withSep.$decimals';
  }
}
