import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ex_9/main.dart';

void main() {
  testWidgets('App loads and shows Update Book Copies screen',
      (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MaterialApp(
      home: UpdateBookScreen(),
    ));

    // Verify that the app title text appears
    expect(find.text('Update Book Copies'), findsOneWidget);

    // Verify that the key TextFields exist
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify that Search and Update buttons exist
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
  });
}
