part of 'export_cubit.dart';

enum ExportAction { shared, saved }

class ExportState {
  const ExportState({
    required this.isLoadingHistory,
    required this.isExporting,
    required this.isSharing,
    required this.isSaving,
    required this.isDeleting,
    required this.history,
    required this.lastExport,
    required this.lastAction,
    required this.errorMessage,
  });

  const ExportState.initial()
    : isLoadingHistory = false,
      isExporting = false,
      isSharing = false,
      isSaving = false,
      isDeleting = false,
      history = const [],
      lastExport = null,
      lastAction = null,
      errorMessage = null;

  final bool isLoadingHistory;
  final bool isExporting;
  final bool isSharing;
  final bool isSaving;
  final bool isDeleting;
  final List<ExportHistoryItem> history;
  final ExportFile? lastExport;
  final ExportAction? lastAction;
  final String? errorMessage;

  ExportState copyWith({
    bool? isLoadingHistory,
    bool? isExporting,
    bool? isSharing,
    bool? isSaving,
    bool? isDeleting,
    List<ExportHistoryItem>? history,
    ExportFile? lastExport,
    ExportAction? lastAction,
    String? errorMessage,
    bool clearLastExport = false,
    bool clearLastAction = false,
  }) {
    return ExportState(
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isExporting: isExporting ?? this.isExporting,
      isSharing: isSharing ?? this.isSharing,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      history: history ?? this.history,
      lastExport: clearLastExport ? null : (lastExport ?? this.lastExport),
      lastAction: clearLastAction ? null : (lastAction ?? this.lastAction),
      errorMessage: errorMessage,
    );
  }
}
