import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/app/routes/app_router.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/core/theme/app_theme.dart';

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
        return MaterialApp(
          title: 'Spend Wise',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          initialRoute: RouteNames.mainShellPage,
          onGenerateRoute: appRouters.onGenerateRoute,
        );
      },
    );
  }
}
