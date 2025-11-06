import 'package:flutter/material.dart';
import 'package:ex_6/databasehelper.dart';
import 'bank.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderController = TextEditingController();
  final _balanceController = TextEditingController();
  List<BankAccount> _accounts = [];

  @override
  void initState() {
    super.initState();
    _showAllAccounts();
  }

  Future<void> _showAllAccounts() async {
    final accounts = await DatabaseHelper.instance.readAllAccounts();
    setState(() {
      _accounts = accounts;
    });
  }

  double getTotalBankBalance() {
    return _accounts.fold(
      0,
      (sum, account) => sum + account.balance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple Bank Account Manager",
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 242, 225),
        appBar: AppBar(
          title: const Text("Simple Bank Account Manager"),
          backgroundColor: const Color.fromARGB(255, 255, 175, 2),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Account Holder Name
                TextFormField(
                  controller: _accountHolderController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Enter Account Holder Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the account holder name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Initial Balance
                TextFormField(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter Initial Balance",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the initial balance";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Add Account Button
                Builder(
                  builder: (context) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 132, 31),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String accountHolder = _accountHolderController.text;
                          double balance =
                              double.parse(_balanceController.text);

                          BankAccount account = BankAccount(
                            accountHolder: accountHolder,
                            balance: balance,
                          );

                          await DatabaseHelper.instance.insertAccount(account);
                          await _showAllAccounts();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Account Details Saved")),
                          );

                          _accountHolderController.clear();
                          _balanceController.clear();
                        }
                      },
                      child: const Text("Add Account"),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Display all accounts
                Expanded(
                  child: _accounts.isEmpty
                      ? const Center(child: Text("No accounts found"))
                      : ListView.builder(
                          itemCount: _accounts.length,
                          itemBuilder: (context, index) {
                            final account = _accounts[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: account.balance == 0
                                    ? Colors.red
                                    : Colors.blue,
                                child:
                                    Text(account.accountHolder[0].toUpperCase()),
                              ),
                              title: Text(account.accountHolder),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Balance: ₹${account.balance}"),
                                  if (account.balance == 0)
                                    const Text(
                                      "Low Balance!",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                // Total Bank Balance
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total Money in Bank: ₹${getTotalBankBalance()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
