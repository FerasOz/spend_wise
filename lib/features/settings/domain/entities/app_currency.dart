class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.symbol,
  });

  final String code;
  final String symbol;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppCurrency &&
        other.code == code &&
        other.symbol == symbol;
  }

  @override
  int get hashCode => Object.hash(code, symbol);
}
