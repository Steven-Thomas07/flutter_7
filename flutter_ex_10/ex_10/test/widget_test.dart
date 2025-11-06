import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ex_10/main.dart';

void main() {
  testWidgets('Login Page UI loads correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify key widgets are present
    expect(find.text('User Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Email + Password
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Dashboard page shows welcome message', (WidgetTester tester) async {
    // Build the DashboardPage directly
    await tester.pumpWidget(const MaterialApp(home: DashboardPage(userName: 'Akash')));

    // Verify welcome text
    expect(find.text('Welcome, Akash 👋'), findsOneWidget);
  });
}
