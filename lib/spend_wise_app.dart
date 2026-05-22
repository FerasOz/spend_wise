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
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              ThemeMode activeMode = ThemeMode.system;
              if (state.isInitialized) {
                switch (state.settings!.themeMode) {
                  case AppThemeMode.light:
                    activeMode = ThemeMode.light;
                    break;
                  case AppThemeMode.dark:
                    activeMode = ThemeMode.dark;
                    break;
                  case AppThemeMode.system:
                    activeMode = ThemeMode.system;
                    break;
                }
              }

              return MaterialApp(
                title: 'Spend Wise',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: activeMode,
                initialRoute: RouteNames.mainShellPage,
                onGenerateRoute: appRouters.onGenerateRoute,
              );
            },
          ),
        );
      },
    );
  }
}
