class AppFormatters {
  const AppFormatters._();

  static String currency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  static String shortDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  static String dateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${shortDate(date)} • $hour:$minute';
  }

  static String dateTimeOrFallback(DateTime? date, {String fallback = 'Unavailable'}) {
    if (date == null) {
      return fallback;
    }

    return dateTime(date);
  }
}
