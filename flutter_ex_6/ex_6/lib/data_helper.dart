import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product.dart';

class DatabaseHelper{
  //Create Databse instances
  static Database? _database;
  static DatabaseHelper instance = DatabaseHelper._privateConstructer();
  DatabaseHelper._privateConstructer();

  Future<Database> get database async {
    // When running on web we don't use sqlite. The database getter is only
    // meaningful for non-web platforms.
    if (kIsWeb) {
      throw UnsupportedError('Database (sqflite) is not available on the web. Use web-specific methods.');
    }

    if(_database != null) return _database!;

    // Create/open the sqlite database using the platform's database path
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'accounts.db');
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
  /// Insert account. Uses SharedPreferences JSON-storage on web, and sqlite on other platforms.
  Future<int> insertAccount(Account account) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey) ?? '[]';
      final List list = jsonDecode(raw) as List;
      // Simple auto-increment id using timestamp (safe enough for this sample)
      final id = DateTime.now().millisecondsSinceEpoch;
      final map = account.toMap();
      map['id'] = id;
      list.add(map);
      await prefs.setString(_prefsKey, jsonEncode(list));
      return 1;
    }

    Database db = await instance.database;
    return await db.insert('accounts', account.toMap());
  }

  Future<List<Account>> readAllAccounts() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey) ?? '[]';
      final List list = jsonDecode(raw) as List;
      final accounts = list.reversed.map((e) => Account.fromRow(Map<String, dynamic>.from(e))).toList();
      return accounts.cast<Account>();
    }

    Database db = await instance.database;
    final records = await db.query('accounts', orderBy: 'id DESC');
    return records.map((record) => Account.fromRow(record)).toList();
  }

  Future<double> totalBalance() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey) ?? '[]';
      final List list = jsonDecode(raw) as List;
      double sum = 0.0;
      for (final e in list) {
        final b = (e['balance'] as num?) ?? 0;
        sum += b.toDouble();
      }
      return sum;
    }

    Database db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(balance) as total FROM accounts');
    if (result.isNotEmpty) {
      final value = result.first['total'];
      if (value == null) return 0.0;
      return (value as num).toDouble();
    }
    return 0.0;
  }

  static const String _prefsKey = 'bank_accounts_json_v1';
}