import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'bank.dart';

class DatabaseHelper{
  //Create Database instances
  static Database? _database;
  static DatabaseHelper instance = DatabaseHelper._privateConstructer();
  DatabaseHelper._privateConstructer();

  Future<Database> get database async {
    if(_database != null) return _database!;

    //create database
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "accounts.db");
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql = "CREATE TABLE accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, accountHolder TEXT, balance REAL)";
        await db.execute(sql);
      },
      );
      return _database!;
  }
  //insert Record
  Future<int> insertAccount(BankAccount account) async {
    Database db = await instance.database;
    return await db.insert('accounts', account.toMap());
  }

  Future<List<BankAccount>> readAllAccounts() async {
    Database db = await instance.database;
    final records = await db.query("accounts");
    return records.map((record) => BankAccount.fromRow(record)).toList();
  }
  
  Future<double> getTotalBalance() async {
    Database db = await instance.database;
    final result = await db.rawQuery("SELECT SUM(balance) as total FROM accounts");
    return result.first['total'] as double? ?? 0.0;
  }
}