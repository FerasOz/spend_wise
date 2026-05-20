part of 'insight_cubit.dart';

class InsightState {
  const InsightState.initial()
    : insights = const [],
      isLoading = false,
      error = null;

  const InsightState.loaded(List<InsightCard> insights)
    : insights = insights,
      isLoading = false,
      error = null;

  const InsightState.error(String error)
    : insights = const [],
      isLoading = false,
      error = error;

  final List<InsightCard> insights;
  final bool isLoading;
  final String? error;
}
