import 'package:flutter/material.dart';
import 'bank.dart';
import 'data_helper.dart';
void main() {
  runApp(MaterialApp(
    title: "Bank Account Manager",
    home: BankApp(),
  ));
}

class BankApp extends StatefulWidget {
  const BankApp({super.key});

  @override
  State<BankApp> createState() => _BankAppState();
}

class _BankAppState extends State<BankApp> {
  final _formkey = GlobalKey<FormState>();
  final _accountHolderController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  List<BankAccount> _accounts = [];
  double _totalBalance = 0.0;

  void _showAllAccounts() async {
    final accounts = await DatabaseHelper.instance.readAllAccounts();
    final total = await DatabaseHelper.instance.getTotalBalance();
    setState(() {
      _accounts = accounts;
      _totalBalance = total;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _showAllAccounts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Account Manager"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
          key: _formkey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _accountHolderController,
                  decoration: InputDecoration(
                      labelText: "Enter Account Holder Name",
                      border: OutlineInputBorder()
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Account Holder Name";
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _initialBalanceController,
                  decoration: InputDecoration(
                      labelText: "Enter Initial Balance",
                      border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Enter Initial Balance";
                    }
                    if(double.tryParse(value) == null){
                      return "Enter a valid number";
                    }
                  },
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                        String accountHolder = _accountHolderController.text;
                        double initialBalance = double.parse(_initialBalanceController.text);

                        //Create BankAccount object
                        BankAccount account = BankAccount(
                          accountHolder: accountHolder, 
                          balance: initialBalance
                        );
                        await DatabaseHelper.instance.insertAccount(account);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account Created Successfully"))
                        );
                        _accountHolderController.clear();
                        _initialBalanceController.clear();
                        _showAllAccounts();
                      }
                    },
                    child: Text("Create Account")),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Money in Bank:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${_totalBalance.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Expanded(
                    child: ListView.builder(
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final account = _accounts[index];
                        bool isZeroBalance = account.balance == 0.0;
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isZeroBalance ? Colors.red.shade50 : Colors.white,
                            border: Border.all(
                              color: isZeroBalance ? Colors.red : Colors.grey.shade300,
                              width: isZeroBalance ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isZeroBalance ? Colors.red : Colors.blueAccent,
                              child: Text(
                                account.accountHolder.isNotEmpty 
                                    ? account.accountHolder[0].toUpperCase() 
                                    : "?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              account.accountHolder,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isZeroBalance ? Colors.red.shade900 : Colors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Balance: \$${account.balance.toStringAsFixed(2)}"),
                                if(isZeroBalance)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      "Low Balance!",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                )
              ],
            ),
          )),
    );
  }
}