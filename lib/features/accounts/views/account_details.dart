import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/accounts/viewmodels/account_provider.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/l10n/app_localizations.dart';

import '../../../core/appscolors.dart';
import '../../transaction/viewmodels/transaction_provider.dart';
import '../../uihelper.dart';
import 'addaccount.dart';

class AccountDetailsPage extends StatefulWidget {
  final Map<String, dynamic> account;

  const AccountDetailsPage({super.key, required this.account});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TransactionProvider>().getTransactionsByAccount(
        widget.account['id'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currency = settingsProvider.currency;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppLocalizations.of(context)!.account_details),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              // Confirmation Dialog
              bool? confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Account"),
                  content: const Text(
                    "Are you sure you want to delete this account?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await Provider.of<AccountProvider>(
                  context,
                  listen: false,
                ).deleteAccount(widget.account['id']);

                Navigator.pop(context); // go back after delete
              }
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ACCOUNT CARD
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: AppsColors.primary,
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      uiHelper.CustomText(
                        text: AppLocalizations.of(context)!.total_balance,
                        fontSize: 16,
                        fontweight: FontWeight.bold,
                        color: Colors.white,
                      ),

                      uiHelper.CustomText(
                        text: "${widget.account['balance']} $currency",
                        fontSize: 30,
                        fontweight: FontWeight.bold,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 40),

                      Consumer<TransactionProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  uiHelper.CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.total_income,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  uiHelper.CustomText(
                                    text: "${provider.accountIncome} $currency",
                                    fontSize: 14,
                                    fontweight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  uiHelper.CustomText(
                                    text: AppLocalizations.of(
                                      context,
                                    )!.total_expense,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  uiHelper.CustomText(
                                    text: "${provider.accountExpense} $currency",
                                    fontSize: 14,
                                    fontweight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// TRANSACTION TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppLocalizations.of(context)!.transactions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          /// TRANSACTION LIST
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                final transactions = provider.accountTransactions;

                if (transactions.isEmpty) {
                  return const Center(child: Text("No Transactions"));
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final txn = transactions[index];

                    return Column(
                      children: [
                        ListTile(
                          title: Text(txn['category_name'] ?? ""),

                          subtitle: Text(
                            "${txn['date']} • ${txn['account_name']}",
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppsColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Addaccount(account: widget.account),
            ),
          );
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
