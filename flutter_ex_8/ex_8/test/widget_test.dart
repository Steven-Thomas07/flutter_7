import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ex_8/main.dart';

void main() {
  testWidgets('Library search screen loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LibraryScreen()));

    // Verify app bar title
    expect(find.text('Library Book Search System'), findsOneWidget);

    // Verify Search button
    expect(find.text('Search'), findsOneWidget);

    // Verify text field label
    expect(find.text('Enter Book Title'), findsOneWidget);
  });
}
