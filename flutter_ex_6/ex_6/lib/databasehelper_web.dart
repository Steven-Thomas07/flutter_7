import 'dart:convert';
import 'dart:html' as html;
import 'bank.dart';

class DatabaseHelper {
  // Simple web-backed implementation using window.localStorage.
  // Keeps the same public API as the IO implementation used elsewhere.
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  static const _storageKey = 'ex_6_bank_accounts';

  Future<int> insertAccount(BankAccount account) async {
    final list = _readList();
    final nextId = _nextId(list);
    final entry = {
      'id': nextId,
      'accountHolder': account.accountHolder,
      'balance': account.balance,
    };
    list.add(entry);
    _writeList(list);
    return nextId;
  }

  Future<List<BankAccount>> readAllAccounts() async {
    final list = _readList();
    return list
        .map((row) => BankAccount.fromRow({
              'id': row['id'],
              'accountHolder': row['accountHolder'],
              'balance': (row['balance'] is int)
                  ? (row['balance'] as int).toDouble()
                  : row['balance'],
            }))
        .toList();
  }

  Future<int> resetAccounts() async {
    _writeList([]);
    return 1;
  }

  List<dynamic> _readList() {
    final raw = html.window.localStorage[_storageKey];
    if (raw == null) return [];
    try {
      final parsed = jsonDecode(raw) as List<dynamic>;
      return parsed;
    } catch (e) {
      return [];
    }
  }

  void _writeList(List<dynamic> list) {
    html.window.localStorage[_storageKey] = jsonEncode(list);
  }

  int _nextId(List<dynamic> list) {
    if (list.isEmpty) return 1;
    final ids = list.map((e) => e['id'] as int).toList();
    return (ids.reduce((a, b) => a > b ? a : b)) + 1;
  }
}
