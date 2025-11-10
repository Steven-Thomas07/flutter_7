class BankAccount {
  int? id;
  String accountHolder;
  double balance;
  
  BankAccount({
    this.id,
    required this.accountHolder,
    required this.balance
  });

  factory BankAccount.fromRow(Map<String, dynamic> row){
    return BankAccount(
      id: row['id'],
      accountHolder: row['accountHolder'],
      balance: row['balance']);
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountHolder': accountHolder,
      'balance': balance,
    };
  }
}

