part of 'settings_cubit.dart';

class SettingsState {
  const SettingsState.initial()
    : settings = null,
      isLoading = false,
      error = null;

  const SettingsState.loaded(this.settings)
    : isLoading = false,
      error = null;

  const SettingsState.error(this.error)
    : settings = null,
      isLoading = false;

  final AppSettings? settings;
  final bool isLoading;
  final String? error;

  bool get isInitialized => settings != null;
}
