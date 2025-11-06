// Conditional import facade: picks the correct implementation for the platform.
// On web, `dart.library.html` will select the web implementation which uses
// window.localStorage. On IO (mobile/desktop), the sqflite implementation is used.
import 'databasehelper_io.dart'
    if (dart.library.html) 'databasehelper_web.dart';

// The selected implementation provides `DatabaseHelper` with the same API used
// by the rest of the app (instance, insertAccount, readAllAccounts, resetAccounts).
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'bank.dart';

class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "bankaccounts.db");

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql =
            "CREATE TABLE accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, accountHolder TEXT, balance REAL)";
        await db.execute(sql);
      },
    );
    return _database!;
  }

  Future<int> insertAccount(BankAccount account) async {
    Database db = await instance.database;
    return await db.insert('accounts', {
      'accountHolder': account.accountHolder,
      'balance': account.balance,
    });
  }

  Future<List<BankAccount>> readAllAccounts() async {
    Database db = await instance.database;
    final records = await db.query("accounts");
    return records.map((record) => BankAccount.fromRow(record)).toList();
  }

  Future<int> resetAccounts() async {
    final db = await instance.database;
    return await db.delete("accounts");
  }
}
