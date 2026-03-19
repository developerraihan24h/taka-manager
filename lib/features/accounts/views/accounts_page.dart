import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/core/appscolors.dart';
import 'package:takamanager/features/accounts/viewmodels/account_provider.dart';
import 'package:takamanager/features/accounts/views/addaccount.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/accountscard.dart';
import 'account_details.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AccountProvider>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Icon(Icons.account_balance, color: AppsColors.primary, size: 24.r),
            SizedBox(width: 10.w),
            Text(
              AppLocalizations.of(context)!.bottom_account,
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: "bold",
                color: AppsColors.primary,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(color: Colors.grey.shade200, height: 1.h),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0).r,
        child: Column(
          children: [
            Consumer<AccountProvider>(
              builder: (ctx, provider, child) {
                final accounts = provider.accountList;

                if (accounts.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text("No Account Found")),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AccountDetailsPage(account: account),
                            ),
                          );
                        },
                        child: AccountsCard(
                          accountName: account['account_name'],
                          holderName: account['holder_name'],
                          accountNumber: account['account_number'],
                          balance: (account['balance'] as num).toDouble(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppsColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const Addaccount();
              },
            ),
          );
        },
        child: const Icon(Icons.wallet, color: Colors.white),
      ),
    );
  }
}
