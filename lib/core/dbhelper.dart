import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  //TABLE Name===============================
  static final String TABLE_ACCOUNTS = "accounts";
  static final String TABLE_CATEGORIES = "categories";
  static final String TABLE_TRANSACTIONS = "transactions";
  static final String TABLE_SETTINGS = "settings";

  Database? myDB;

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "taka_manager.db");

    return await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE $TABLE_SETTINGS(
              id INTEGER PRIMARY KEY,
              user_name TEXT,
              profile_image_path TEXT,
              currency TEXT,
              language_code TEXT,
              theme_mode TEXT
            )
          ''');
          await db.insert(TABLE_SETTINGS, {
            'id': 1,
            'user_name': '', // Empty for first time check
            'profile_image_path': null,
            'currency': '৳',
            'language_code': 'en',
            'theme_mode': 'light',
          });
        } else if (oldVersion < 3) {
          await db.execute('ALTER TABLE $TABLE_SETTINGS ADD COLUMN theme_mode TEXT DEFAULT "light"');
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
        CREATE TABLE $TABLE_ACCOUNTS(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          account_name TEXT,
          holder_name TEXT,
          account_number TEXT,
          balance REAL
        )
      ''');

    await db.insert(TABLE_ACCOUNTS, {
      'account_name': 'Cash',
      'holder_name': 'Cash Name',
      'account_number': '0001',
      'balance': 0.0,
    });

    await db.insert(TABLE_ACCOUNTS, {
      'account_name': 'Bank',
      'holder_name': 'Bank Name',
      'account_number': '0002',
      'balance': 0.0,
    });

    await db.execute('''
        CREATE TABLE $TABLE_CATEGORIES(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category_name TEXT,
          short_description TEXT,
          type TEXT
        )
      ''');

    await db.insert(TABLE_CATEGORIES, {'category_name': 'Food', 'short_description': 'Daily meals and groceries', 'type': 'expense'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Transport', 'short_description': 'Bus, CNG, fuel cost', 'type': 'expense'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Shopping', 'short_description': 'Clothes and accessories', 'type': 'expense'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Bills', 'short_description': 'Electricity, gas, internet', 'type': 'expense'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Entertainment', 'short_description': 'Movies, outings', 'type': 'expense'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Salary', 'short_description': 'Monthly salary income', 'type': 'income'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Business', 'short_description': 'Business profit', 'type': 'income'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Freelance', 'short_description': 'Freelancing income', 'type': 'income'});
    await db.insert(TABLE_CATEGORIES, {'category_name': 'Gift', 'short_description': 'Received gifts', 'type': 'income'});

    await db.execute('''
        CREATE TABLE $TABLE_TRANSACTIONS(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount REAL,
          description TEXT,
          account_id INTEGER,
          category_id INTEGER,
          type TEXT,
          date TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE $TABLE_SETTINGS(
          id INTEGER PRIMARY KEY,
          user_name TEXT,
          profile_image_path TEXT,
          currency TEXT,
          language_code TEXT,
          theme_mode TEXT
        )
      ''');

    await db.insert(TABLE_SETTINGS, {
      'id': 1,
      'user_name': '', // Empty for first time check
      'profile_image_path': null,
      'currency': '৳',
      'language_code': 'en',
      'theme_mode': 'light',
    });
  }
}
