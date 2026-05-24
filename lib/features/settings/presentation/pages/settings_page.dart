import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/core/widgets/responsive_page_content.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/app_info_sliver.dart';
import '../widgets/appearance_section.dart';
import '../widgets/about_section.dart';
import '../widgets/data_section.dart';
import '../widgets/notifications_section.dart';
import '../widgets/preferences_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.app_settings.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (!state.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings!;
          return ResponsivePageContent(
            child: CustomScrollView(
              slivers: [
                AppInfoSliver(settings: settings),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      AppearanceSection(settings: settings),
                      PreferencesSection(settings: settings),
                      NotificationsSection(settings: settings),
                      DataSection(settings: settings),
                      const AboutSection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
