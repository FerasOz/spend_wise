import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.sync_outlined),
            title: Text('Sync'),
            subtitle: Text('Firebase sync options will live here.'),
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Manage subscription reminders and alerts.'),
          ),
          ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text('Privacy'),
            subtitle: Text('Control backup, local storage, and security settings.'),
          ),
        ],
      ),
    );
  }
}
