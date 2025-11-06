import 'package:flutter/material.dart';
import 'budget_data_model.dart';

class BudgetResultScreen extends StatelessWidget {
  const BudgetResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budget = ModalRoute.of(context)!.settings.arguments as BudgetData;

    double remaining = budget.income - (budget.rent + budget.food + budget.transport + budget.others);
    bool isOverspending = remaining < 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Report'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Income and Outgoings
            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Monthly Income'),
                trailing: Text(budget.income.toStringAsFixed(2)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Rent/EMI'),
                trailing: Text(budget.rent.toStringAsFixed(2)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.fastfood),
                title: Text('Food Expenses'),
                trailing: Text(budget.food.toStringAsFixed(2)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.directions_bus),
                title: Text('Transport Expenses'),
                trailing: Text(budget.transport.toStringAsFixed(2)),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.miscellaneous_services),
                title: Text('Other Expenses'),
                trailing: Text(budget.others.toStringAsFixed(2)),
              ),
            ),
            SizedBox(height: 20),
            // Remaining Balance
            Card(
              color: isOverspending ? Colors.red.shade100 : Colors.green.shade100,
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text(
                  'Remaining Balance',
                  style: TextStyle(
                    color: isOverspending ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  remaining.toStringAsFixed(2),
                  style: TextStyle(
                    color: isOverspending ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isOverspending
                    ? Text(
                        'You are overspending!',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                      )
                    : Text(
                        'Good! You are within budget.',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
