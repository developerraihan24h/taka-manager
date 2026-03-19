import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/core/appscolors.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/features/reports/views/report_page.dart';
import 'package:takamanager/features/transaction/views/add_expense.dart';
import 'package:takamanager/features/transaction/views/add_income.dart';
import 'package:takamanager/features/uihelper.dart';
import 'package:takamanager/l10n/app_localizations.dart';

import '../../accounts/viewmodels/account_provider.dart';
import '../../common/customappbar.dart';
import '../../transaction/viewmodels/transaction_provider.dart';
import '../widgets/treadcard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TransactionProvider>().loadLast30DaysTrend();
    });

    Future.microtask(() {
      context.read<TransactionProvider>().getRecentTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currency = settingsProvider.currency;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer2<AccountProvider, TransactionProvider>(
                builder: (context, accountProvider, transactionProvider, child) {
                  double totalBalance = accountProvider.totalBalance;
                  double totalIncome = transactionProvider.totalIncome;
                  double totalExpense = transactionProvider.totalExpense;

                  return Card(
                    color: AppsColors.primary,
                    elevation: 1,
                    child: Container(
                      constraints: BoxConstraints(minHeight: 180.h),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            uiHelper.CustomText(
                              text: AppLocalizations.of(context)!.total_balance,
                              fontSize: 20.sp,
                              fontweight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            uiHelper.CustomText(
                              text:
                                  "${totalBalance.toStringAsFixed(2)} $currency",
                              fontSize: 30.sp,
                              fontweight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              children: [
                                /// INCOME
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      uiHelper.CustomText(
                                        text: AppLocalizations.of(
                                          context,
                                        )!.total_income,
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                      uiHelper.CustomText(
                                        text:
                                            "${totalIncome.toStringAsFixed(2)} $currency",
                                        fontSize: 16.sp,
                                        fontweight: FontWeight.bold,
                                        color: Colors.greenAccent,
                                      ),
                                    ],
                                  ),
                                ),

                                /// EXPENSE
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      uiHelper.CustomText(
                                        text: AppLocalizations.of(
                                          context,
                                        )!.total_expense,
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                      uiHelper.CustomText(
                                        text:
                                            "${totalExpense.toStringAsFixed(2)} $currency",
                                        fontSize: 16.sp,
                                        fontweight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  return TrendChartCard(
                    spots: provider.last30DaysSpots,
                    total: provider.last30DaysTotal,
                  );
                },
              ),

              ///Recent transactions========================
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    uiHelper.CustomText(
                      text: AppLocalizations.of(context)!.recent_transactions,
                      fontSize: 18.sp,
                      fontweight: FontWeight.bold,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportPage(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.see_all,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppsColors.textcolorBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  final transactions = provider.transactionList;

                  if (transactions.isEmpty) {
                    return const Center(child: Text("No Transactions"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final txn = transactions[index];
                      DateTime dateTime = DateTime.parse(txn['date']);
                      String formattedDate = DateFormat(
                        'dd MMM',
                      ).format(dateTime);
                      String formattedTime = DateFormat(
                        'hh:mm a',
                      ).format(dateTime);

                      return Column(
                        children: [
                          ListTile(
                            title: Text(txn['category_name'] ?? ""),
                            subtitle: Text(
                              "$formattedDate • $formattedTime • ${txn['account_name']}",
                            ),
                            trailing: Text(
                              "${txn['amount']} $currency",
                              style: TextStyle(
                                color: txn['type'] == "income"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black12,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppsColors.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(AppLocalizations.of(context)!.transaction_type),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppsColors.primary,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddIncome(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.add_income,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // close dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddExpense(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.add_expense,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
