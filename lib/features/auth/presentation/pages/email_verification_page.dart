import 'package:flutter/material.dart';
import 'package:spend_wise/app/routes/route_names.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).pushNamed(RouteNames.emailVerificationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check your email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 72),
            const SizedBox(height: 16),
            const Text(
              'We sent a confirmation email. Please verify it before signing in.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).pushReplacementNamed(RouteNames.loginPage),
              icon: const Icon(Icons.login),
              label: const Text('Open login'),
            ),
          ],
        ),
      ),
    );
  }
}
