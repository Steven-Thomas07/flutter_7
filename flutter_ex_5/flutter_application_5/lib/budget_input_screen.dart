import 'package:flutter/material.dart';
import 'budget_data_model.dart';

class BudgetInputScreen extends StatefulWidget {
  const BudgetInputScreen({super.key});

  @override
  _BudgetInputScreenState createState() => _BudgetInputScreenState();
}

class _BudgetInputScreenState extends State<BudgetInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _foodController = TextEditingController();
  final _transportController = TextEditingController();
  final _othersController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Input Form'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Monthly Income
                TextFormField(
                  controller: _incomeController,
                  decoration: InputDecoration(
                    labelText: 'Monthly Income',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter monthly income';
                    }
                    final v = double.tryParse(value);
                    if (v == null || v <= 0) {
                      return 'Income must be positive';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Rent/EMI
                TextFormField(
                  controller: _rentController,
                  decoration: InputDecoration(
                    labelText: 'Rent/EMI',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter rent/EMI' : null,
                ),
                SizedBox(height: 20),
                // Food Expenses
                TextFormField(
                  controller: _foodController,
                  decoration: InputDecoration(
                    labelText: 'Food Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter food expenses' : null,
                ),
                SizedBox(height: 20),
                // Transport Expenses
                TextFormField(
                  controller: _transportController,
                  decoration: InputDecoration(
                    labelText: 'Transport Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter transport expenses' : null,
                ),
                SizedBox(height: 20),
                // Other Expenses
                TextFormField(
                  controller: _othersController,
                  decoration: InputDecoration(
                    labelText: 'Other Expenses',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Enter other expenses' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final budget = BudgetData(
                        income: double.parse(_incomeController.text),
                        rent: double.parse(_rentController.text),
                        food: double.parse(_foodController.text),
                        transport: double.parse(_transportController.text),
                        others: double.parse(_othersController.text),
                      );
                      Navigator.pushNamed(
                        context,
                        '/result',
                        arguments: budget,
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
