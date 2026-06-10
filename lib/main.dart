import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/app/routes/app_router.dart';
import 'package:spend_wise/spend_wise_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/codegen_loader.g.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ajiemrghhcdzianarhzk.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFqaWVtcmdoaGNkemlhbmFyaHprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEwODE2MzEsImV4cCI6MjA5NjY1NzYzMX0.yFhR7ge6xeW2W5bQMzj4tWB7ftbo533CRxjdn3Yk-o4',
  );
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
