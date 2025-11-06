import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ex_6/main.dart';

void main() {
  testWidgets('Add Account form and list display test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the main title is shown
    expect(find.text('Simple Bank Account Manager'), findsOneWidget);

    // Find the input fields and button
    final accountHolderField = find.byType(TextFormField).at(0);
    final balanceField = find.byType(TextFormField).at(1);
    final addButton = find.text('Add Account');

    // Enter data into the form fields
    await tester.enterText(accountHolderField, 'John Doe');
    await tester.enterText(balanceField, '1000');

    // Tap the Add Account button
    await tester.tap(addButton);
    await tester.pump(const Duration(seconds: 1)); // simulate UI refresh

    // Verify Snackbar message
    expect(find.text('Account Details Saved'), findsOneWidget);

    // After save, verify input fields are cleared
    expect(find.text('John Doe'), findsNothing);
    expect(find.text('1000'), findsNothing);
  });
}
