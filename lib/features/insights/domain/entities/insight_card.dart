class InsightCard {
  const InsightCard({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.icon,
    required this.color,
    this.value,
    this.subtitle,
  });

  final String id;
  final String title;
  final String message;
  final InsightType type;
  final String icon;
  final int color;
  final String? value;
  final String? subtitle;
}

enum InsightType {
  topCategory,
  spending_trend,
  average_daily,
  highest_spending_day,
  spending_streak,
  smart_recommendation,
}
