import 'package:flutter/material.dart';
import 'product.dart';
import 'data_helper.dart';

void main() {
  runApp(MaterialApp(
    title: "Simple Bank Account Manager",
    home: BankApp(),
  ));
}

class BankApp extends StatefulWidget {
  const BankApp({super.key});

  @override
  State<BankApp> createState() => _BankAppState();
}

class _BankAppState extends State<BankApp> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  List<Account> _accounts = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final accounts = await DatabaseHelper.instance.readAllAccounts();
    final total = await DatabaseHelper.instance.totalBalance();
    setState(() {
      _accounts = accounts;
      _total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Total money in bank: \$${_total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Account holder name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter account holder name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _balanceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Initial balance',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter initial balance';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final name = _nameController.text.trim();
                        final balance = double.parse(_balanceController.text.trim());
                        final account = Account(accountHolder: name, balance: balance);
                        final messenger = ScaffoldMessenger.of(context);
                        await DatabaseHelper.instance.insertAccount(account);
                        messenger.showSnackBar(SnackBar(content: Text('Account saved')));
                        _nameController.clear();
                        _balanceController.clear();
                        await _refresh();
                      }
                    },
                    child: Text('Save Account'),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: _accounts.isEmpty
                  ? Center(child: Text('No accounts yet'))
                  : ListView.builder(
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final acc = _accounts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(child: Text(acc.accountHolder.isNotEmpty ? acc.accountHolder[0].toUpperCase() : '?')),
                            title: Text(acc.accountHolder),
                            subtitle: Text('Balance: \$${acc.balance.toStringAsFixed(2)}'),
                            trailing: acc.balance == 0
                                ? Text('Low Balance!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                : null,
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}