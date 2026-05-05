import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';

import '../../../core/appscolors.dart';
import '../../../l10n/app_localizations.dart';
import '../../accounts/viewmodels/account_provider.dart';
import '../../transaction/viewmodels/transaction_provider.dart';
import '../../uihelper.dart';
import '../widgets/monthlyfilter.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TransactionProvider>().getTransactionsByMonth(
        selectedMonth.month,
      );
    });
  }

  double getIncome(List transactions) {
    double total = 0;

    for (var txn in transactions) {
      if (txn['type'] == "income") {
        total += double.tryParse(txn['amount'].toString()) ?? 0;
      }
    }

    return total;
  }

  double getExpense(List transactions) {
    double total = 0;

    for (var txn in transactions) {
      if (txn['type'] == "expense") {
        total += double.tryParse(txn['amount'].toString()) ?? 0;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currency = settingsProvider.currency;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Icon(Icons.report),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.bottom_reports,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "bold",
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Theme.of(context).dividerColor, height: 1),
        ),
      ),
      body: Column(
        children: [
          /// Month Filter
          MonthFilterBar(
            onMonthChanged: (month) {
              setState(() {
                selectedMonth = month;
              });

              context.read<TransactionProvider>().getTransactionsByMonth(
                month.month,
              );
            },
          ),

          Expanded(
            child: Consumer2<AccountProvider, TransactionProvider>(
              builder: (context, accountProvider, transactionProvider, child) {
                final transactions = transactionProvider.monthlyTransactions;

                double totalIncome = getIncome(transactions);
                double totalExpense = getExpense(transactions);
                double totalBalance = totalIncome - totalExpense;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      /// ================= BALANCE CARD =================
                      Card(
                        margin: const EdgeInsets.all(12),
                        color: AppsColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              uiHelper.CustomText(
                                text: AppLocalizations.of(context)!.total_balance,
                                fontSize: 18,
                                fontweight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              uiHelper.CustomText(
                                text: "${totalBalance.toStringAsFixed(2)} $currency",
                                fontSize: 28,
                                fontweight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Income
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      uiHelper.CustomText(
                                        text: AppLocalizations.of(context)!.total_income,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      uiHelper.CustomText(
                                        text: "${totalIncome.toStringAsFixed(2)} $currency",
                                        fontSize: 16,
                                        fontweight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),

                                  /// Expense
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      uiHelper.CustomText(
                                        text: AppLocalizations.of(context)!.total_expense,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      uiHelper.CustomText(
                                        text: "${totalExpense.toStringAsFixed(2)} $currency",
                                        fontSize: 16,
                                        fontweight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// ================= TRANSACTION TITLE =================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            uiHelper.CustomText(
                              text: AppLocalizations.of(context)!.recent_transactions,
                              fontSize: 18,
                              fontweight: FontWeight.bold,
                              context: context,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                AppLocalizations.of(context)!.see_all,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppsColors.textcolorBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ================= TRANSACTION LIST =================
                      if (transactions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text("No Transactions")),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final txn = transactions[index];
                            DateTime dateTime = DateTime.parse(txn['date']);
                            String formattedDate = DateFormat('dd MMM').format(dateTime);
                            String formattedTime = DateFormat('hh:mm a').format(dateTime);

                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
                                    child: const Icon(Icons.wallet),
                                  ),
                                  title: Text(txn['category_name'] ?? ""),
                                  subtitle: Text(
                                    "$formattedDate • $formattedTime • ${txn['account_name']}",
                                  ),
                                  trailing: Text(
                                    "${txn['amount']} $currency",
                                    style: TextStyle(
                                      color: txn['type'] == "income" ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Divider(height: 1),
                              ],
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
