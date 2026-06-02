part of 'insight_cubit.dart';

class InsightState {
  const InsightState.initial()
    : insights = const [],
      isLoading = false,
      error = null;

  const InsightState.loaded(this.insights)
    : isLoading = false,
      error = null;

  const InsightState.error(this.error)
    : insights = const [],
      isLoading = false;

  final List<InsightCard> insights;
  final bool isLoading;
  final String? error;
}
