import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/app/routes/app_router.dart';
import 'package:spend_wise/spend_wise_app.dart';
import 'generated/codegen_loader.g.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: CodegenLoader(),
      child: SpendWiseApp(appRouters: AppRouters()),
    ),
  );
}
