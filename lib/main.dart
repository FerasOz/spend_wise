import 'package:flutter/material.dart';
import 'package:spend_wise/app/routes/app_router.dart';
import 'package:spend_wise/spend_wise_app.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  runApp(SpendWiseApp(appRouters: AppRouters()));
}
