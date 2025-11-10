import 'package:flutter/material.dart';
import 'budget_input_screen.dart';
import 'budget_result_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monthly Budget Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => BudgetInputScreen(),
        '/result': (context) => BudgetResultScreen(),
      },
    );
  }
}
