// Re-purposed file: define an Account model for the bank app
class Account {
  int? id;
  String accountHolder;
  double balance;

  Account({this.id, required this.accountHolder, required this.balance});

  factory Account.fromRow(Map<String, dynamic> row) {
    return Account(
      id: row['id'] is int ? row['id'] : (row['id'] as num?)?.toInt(),
      accountHolder: row['accountHolder'],
      balance: (row['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'accountHolder': accountHolder,
      'balance': balance,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}