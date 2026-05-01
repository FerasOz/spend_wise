import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/config/routes/app_router.dart';
import 'package:spend_wise/config/routes/route_names.dart';

class SpendWiseApp extends StatelessWidget {
  final AppRouters appRouters;
  const SpendWiseApp({super.key, required this.appRouters});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
          title: 'Spend Wise',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F766E),
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F7F6),
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          initialRoute: RouteNames.categoryListPage,
          onGenerateRoute: appRouters.onGenerateRoute,
        )
    );
  }
}
