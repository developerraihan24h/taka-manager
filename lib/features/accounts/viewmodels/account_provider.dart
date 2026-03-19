import 'package:flutter/cupertino.dart';
import 'package:takamanager/core/dbhelper.dart';

class AccountProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _accounts = [];

  List<Map<String, dynamic>> get accountList => _accounts;

  // Load Accounts==========
  Future loadAccounts() async {
    final db = await DBHelper.getInstance.getDB(); // ✅ FIXED

    _accounts = await db!.query(DBHelper.TABLE_ACCOUNTS);
    notifyListeners();
  }

  //Add Account ==================

  Future AddAccount(
    String name,
    String holderName,
    String accountNumber,
    double balance,
  ) async {
    final db = await DBHelper.getInstance.getDB();

    await db!.insert(DBHelper.TABLE_ACCOUNTS, {
      'account_name': name,
      'holder_name': holderName,
      'account_number': accountNumber,
      'balance': balance,
    });

    await loadAccounts();
  }

  // Update Account ==================
  Future updateAccount(
    int id,
    String name,
    String holderName,
    String accountNumber,
    double balance,
  ) async {
    final db = await DBHelper.getInstance.getDB();

    await db.update(
      DBHelper.TABLE_ACCOUNTS,
      {
        'account_name': name,
        'holder_name': holderName,
        'account_number': accountNumber,
        'balance': balance,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadAccounts(); // refresh list
  }

  // Delete Account ==================

  Future deleteAccount(int id) async {
    final db = await DBHelper.getInstance.getDB();

    await db.delete(DBHelper.TABLE_ACCOUNTS, where: 'id = ?', whereArgs: [id]);

    await loadAccounts();
  }



  Future updateAccountBalance(int id, double amount) async {
    final db = await DBHelper.getInstance.myDB;

    final account = _accounts.firstWhere((acc) => acc['id'] == id);

    double currentBalance = account['balance'];

    double newBalance = currentBalance + amount;
    // income → +amount
    // expense → -amount

    await db!.update(
      DBHelper.TABLE_ACCOUNTS,
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadAccounts();
  }


//===========================
  double get totalBalance {
    double total = 0;
    for (var acc in accountList) {
      total += double.tryParse(acc['balance'].toString()) ?? 0;
    }
    return total;
  }




}
