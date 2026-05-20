part of 'settings_cubit.dart';

class SettingsState {
  const SettingsState.initial()
    : settings = null,
      isLoading = false,
      error = null;

  const SettingsState.loaded(AppSettings settings)
    : settings = settings,
      isLoading = false,
      error = null;

  const SettingsState.error(String error)
    : settings = null,
      isLoading = false,
      error = error;

  final AppSettings? settings;
  final bool isLoading;
  final String? error;

  bool get isInitialized => settings != null;
}
