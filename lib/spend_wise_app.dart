import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/app/routes/app_router.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/core/di/injection_container.dart';
import 'package:spend_wise/core/theme/app_theme.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';

class SpendWiseApp extends StatelessWidget {
  final AppRouters appRouters;
  const SpendWiseApp({super.key, required this.appRouters});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<SettingsCubit>(
          create: (_) => sl<SettingsCubit>(),
          child: BlocConsumer<SettingsCubit, SettingsState>(
            listenWhen: (previous, current) =>
                current.isInitialized &&
                previous.settings?.language != current.settings?.language,
            listener: (context, state) {
              final locale = _localeFor(state.settings?.language);
              if (context.locale != locale) {
                context.setLocale(locale);
              }
            },
            builder: (context, state) {
              return MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                title: 'Spend Wise',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: _themeModeFor(state.settings?.themeMode),
                initialRoute: RouteNames.mainShellPage,
                onGenerateRoute: appRouters.onGenerateRoute,
              );
            },
          ),
        );
      },
    );
  }

  ThemeMode _themeModeFor(AppThemeMode? mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      case null:
        return ThemeMode.system;
    }
  }

  Locale _localeFor(AppLanguage? language) {
    switch (language) {
      case AppLanguage.arabic:
        return const Locale('ar');
      case AppLanguage.english:
      case null:
        return const Locale('en');
    }
  }
}
