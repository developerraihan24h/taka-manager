import 'package:flutter/cupertino.dart';
import 'package:takamanager/core/dbhelper.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionProvider with ChangeNotifier {
  List<Map<String, dynamic>> transactionList = [];
  List<Map<String, dynamic>> monthlyTransactions = [];

  //add income====================
  Future addIncome(
    double amount,
    String desc,
    int accountId,
    int categoryId,
    DateTime dateTime,
  ) async {
    final db = await DBHelper.getInstance.getDB();

    await db.transaction((txn) async {
      await txn.insert('transactions', {
        'amount': amount,
        'description': desc,
        'account_id': accountId,
        'category_id': categoryId,
        'type': 'income',
        'date': dateTime.toIso8601String(),
      });

      await txn.rawUpdate(
        '''
        UPDATE accounts
        SET balance = balance + ?
        WHERE id = ?
      ''',
        [amount, accountId],
      );
    });

    notifyListeners();
    await getRecentTransactions();
    await loadCurrentMonthTotals();
  }

  Future addExpense(
    double amount,
    String desc,
    int accountId,
    int categoryId,
    DateTime dateTime,
  ) async {
    final db = await DBHelper.getInstance.getDB();

    await db.transaction((txn) async {
      await txn.insert('transactions', {
        'amount': amount,
        'description': desc,
        'account_id': accountId,
        'category_id': categoryId,
        'type': 'expense',
        'date': dateTime.toIso8601String(),
      });

      await txn.rawUpdate(
        '''
        UPDATE accounts
        SET balance = balance - ?
        WHERE id = ?
      ''',
        [amount, accountId],
      );
    });

    notifyListeners();

    await getRecentTransactions();
    await loadCurrentMonthTotals();
  }

  //================================
  double currentMonthIncome = 0;
  double currentMonthExpense = 0;
  double lastMonthIncome = 0;
  double lastMonthExpense = 0;

  Future loadCurrentMonthTotals() async {
    final db = await DBHelper.getInstance.getDB();
    final now = DateTime.now();
    
    // Current Month
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();

    // Last Month
    final lastMonthDate = DateTime(now.year, now.month - 1);
    final lMonth = lastMonthDate.month.toString().padLeft(2, '0');
    final lYear = lastMonthDate.year.toString();

    final currentResult = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as expense
      FROM transactions
      WHERE strftime('%m', date) = ? AND strftime('%Y', date) = ?
    ''', [month, year]);

    final lastResult = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as expense
      FROM transactions
      WHERE strftime('%m', date) = ? AND strftime('%Y', date) = ?
    ''', [lMonth, lYear]);

    if (currentResult.isNotEmpty) {
      currentMonthIncome = (currentResult[0]['income'] as num?)?.toDouble() ?? 0;
      currentMonthExpense = (currentResult[0]['expense'] as num?)?.toDouble() ?? 0;
    } else {
      currentMonthIncome = 0;
      currentMonthExpense = 0;
    }

    if (lastResult.isNotEmpty) {
      lastMonthIncome = (lastResult[0]['income'] as num?)?.toDouble() ?? 0;
      lastMonthExpense = (lastResult[0]['expense'] as num?)?.toDouble() ?? 0;
    } else {
      lastMonthIncome = 0;
      lastMonthExpense = 0;
    }

    notifyListeners();
  }

  double get totalIncome {
    double total = 0;
    for (var txn in transactionList) {
      if (txn['type'] == 'income') {
        total += double.tryParse(txn['amount'].toString()) ?? 0;
      }
    }
    return total;
  }

  double get totalExpense {
    double total = 0;
    for (var txn in transactionList) {
      if (txn['type'] == 'expense') {
        total += double.tryParse(txn['amount'].toString()) ?? 0;
      }
    }
    return total;
  }
  //========================

  List<FlSpot> last30DaysSpots = [];
  double last30DaysTotal = 0;

  Future loadLast30DaysTrend() async {
    final db = await DBHelper.getInstance.getDB();

    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(const Duration(days: 30));

    final data = await db.rawQuery(
      '''
    SELECT 
      date(date) as txn_date,
      SUM(
        CASE 
          WHEN type = 'income' THEN amount
          WHEN type = 'expense' THEN -amount
        END
      ) as total
    FROM transactions
    WHERE date(date) >= date(?)
    GROUP BY date(date)
    ORDER BY date(date)
  ''',
      [startDate.toIso8601String()],
    );

    last30DaysSpots.clear();
    last30DaysTotal = 0;

    Map<String, double> dailyMap = {};

    for (var row in data) {
      dailyMap[row['txn_date'].toString()] = (row['total'] as num).toDouble();
    }

    for (int i = 0; i < 30; i++) {
      DateTime day = startDate.add(Duration(days: i));
      String key = day.toIso8601String().split("T").first;

      double value = dailyMap[key] ?? 0;

      last30DaysTotal += value;

      last30DaysSpots.add(FlSpot(i.toDouble(), value));
    }

    notifyListeners();
  }

  //============================
  Future getRecentTransactions() async {
    final db = await DBHelper.getInstance.getDB();

    transactionList = await db.rawQuery('''
  SELECT 
  transactions.amount,
  transactions.type,
  transactions.date,
  categories.category_name,
  accounts.account_name
  FROM transactions
  LEFT JOIN categories
  ON transactions.category_id = categories.id
  LEFT JOIN accounts
  ON transactions.account_id = accounts.id
  ORDER BY transactions.date DESC
  LIMIT 10
  ''');

    notifyListeners();
  }

  ///=========================

  List<Map<String, dynamic>> accountTransactions = [];

  Future getTransactionsByAccount(int accountId) async {
    final db = await DBHelper.getInstance.getDB();

    accountTransactions = await db.rawQuery('''
  SELECT 
    transactions.amount,
    transactions.type,
    transactions.date,
    categories.category_name,
    accounts.account_name
  FROM transactions
  LEFT JOIN categories
    ON transactions.category_id = categories.id
  LEFT JOIN accounts
    ON transactions.account_id = accounts.id
  WHERE transactions.account_id = ?
  ORDER BY transactions.date DESC
  ''', [accountId]);

    notifyListeners();
  }


  //================================
  double get accountIncome {
    double total = 0;

    for (var txn in accountTransactions) {
      if (txn['type'] == 'income') {
        total += double.tryParse(txn['amount'].toString()) ?? 0;
      }
    }

    return total;
  }

  double get accountExpense {
    double total = 0;

    for (var txn in accountTransactions) {
      if (txn['type'] == 'expense') {
        total += double.tryParse(txn['amount'].toString()) ?? 0;
      }
    }

    return total;
  }

  ///==========================

  Future<Map<int, Map<String, dynamic>>> getCategoryStats(String type) async {
    final db = await DBHelper.getInstance.getDB();

    final data = await db.rawQuery('''
    SELECT 
      category_id,
      COUNT(*) as total_txn,
      SUM(amount) as total_amount
    FROM transactions
    WHERE type = ?
    GROUP BY category_id
  ''', [type]);

    Map<int, Map<String, dynamic>> result = {};

    for (var row in data) {
      result[row['category_id'] as int] = {
        "count": row['total_txn'] ?? 0,
        "amount": row['total_amount'] ?? 0,
      };
    }

    return result;
  }


  ///===================================
  Future getTransactionsByMonth(int month) async {
    final db = await DBHelper.getInstance.getDB();

    monthlyTransactions = await db.rawQuery('''
  SELECT 
  transactions.amount,
  transactions.type,
  transactions.date,
  categories.category_name,
  accounts.account_name
  FROM transactions
  LEFT JOIN categories
  ON transactions.category_id = categories.id
  LEFT JOIN accounts
  ON transactions.account_id = accounts.id
  WHERE strftime('%m', transactions.date) = ?
  ORDER BY transactions.date DESC
  ''', [month.toString().padLeft(2, '0')]);

    notifyListeners();
  }




}
