import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/app/routes/route_names.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class MainShellDrawer extends StatelessWidget {
  const MainShellDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  LocaleKeys.app_title.tr(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: Text(LocaleKeys.budgets_title.tr()),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteNames.budgetPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(LocaleKeys.app_settings.tr()),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RouteNames.settingsPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(LocaleKeys.app_about.tr()),
              onTap: () {
                Navigator.of(context).pop();
                showAboutDialog(
                  context: context,
                  applicationName: LocaleKeys.app_title.tr(),
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Smart Expense & Subscription Tracker',
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Divider(color: Theme.of(context).dividerColor),
            ),
          ],
        ),
      ),
    );
  }
}
