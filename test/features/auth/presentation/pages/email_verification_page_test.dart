import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/auth/presentation/pages/email_verification_page.dart';

void main() {
  testWidgets('shows email verification guidance', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EmailVerificationPage()));

    expect(find.text('Check your email'), findsOneWidget);
    expect(find.text('Open login'), findsOneWidget);
  });
}
