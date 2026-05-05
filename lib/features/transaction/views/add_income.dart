import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/core/appscolors.dart';
import 'package:takamanager/core/dbhelper.dart';
import 'package:takamanager/features/accounts/viewmodels/account_provider.dart';
import 'package:takamanager/features/uihelper.dart';
import 'package:takamanager/l10n/app_localizations.dart';

import '../../categorys/viewmodels/category_provider.dart';
import '../../home/widgets/accountandcategorycard.dart';
import '../viewmodels/transaction_provider.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  TextEditingController AmountController = TextEditingController();
  TextEditingController desController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  int? selectedAccountId;
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryBg = isDark ? Colors.grey.shade800 : AppsColors.secondaryBackground;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: uiHelper.CustomText(
          text: AppLocalizations.of(context)!.add_income,
          fontSize: 20,
          fontweight: FontWeight.bold,
          context: context,
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                uiHelper.CustomText(
                  text: AppLocalizations.of(context)!.add_amount,
                  fontSize: 16,
                  fontfamily: "bold",
                  context: context,
                ),

                ///Amount===========================
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: secondaryBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: AmountController,
                    textAlign: TextAlign.center, // পুরো text center
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppsColors.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                ///Description===========================
                Description(secondaryBg),

                SizedBox(height: 4),

                ///Date piccker===========================
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBg,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.edit_calendar_outlined),
                          SizedBox(width: 5),

                          uiHelper.CustomText(
                            text: AppLocalizations.of(context)!.date,
                            fontSize: 16,
                            fontweight: FontWeight.bold,
                            context: context,
                          ),

                          Spacer(),

                          uiHelper.CustomText(
                            text:
                                "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}, "
                                "${TimeOfDay.fromDateTime(selectedDateTime).format(context)}",
                            fontSize: 14,
                            context: context,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4),

                ///Selected Account===========================
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: secondaryBg,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          // 🔹 Row with icon and selected account name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Consumer<AccountProvider>(
                              builder: (context, provider, child) {
                                // Safe way to get selected account name
                                String selectedAccountName = "Select";

                                if (selectedAccountId != null) {
                                  final matchedAccounts = provider.accountList
                                      .where(
                                        (acc) => acc['id'] == selectedAccountId,
                                      )
                                      .toList();

                                  if (matchedAccounts.isNotEmpty) {
                                    selectedAccountName =
                                        matchedAccounts.first['account_name'];
                                  }
                                }

                                return Row(
                                  children: [
                                    const Icon(Icons.wallet),
                                    const SizedBox(width: 5),

                                    uiHelper.CustomText(
                                      text: AppLocalizations.of(context)!.account_select,
                                      fontSize: 16,
                                      fontweight: FontWeight.bold,
                                      context: context,
                                    ),

                                    const Spacer(),

                                    uiHelper.CustomText(
                                      text: selectedAccountName,
                                      fontSize: 14,
                                      context: context,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          // 🔹 Grid of accounts
                          Consumer<AccountProvider>(
                            builder: (context, provider, child) {
                              final accounts = provider.accountList;

                              if (accounts.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("No Accounts Found"),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                itemCount: accounts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.75,
                                    ),
                                itemBuilder: (context, index) {
                                  final account = accounts[index];

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedAccountId =
                                            account['id']; // save selected id
                                      });
                                    },
                                    child: AccountAndCategoryCard(
                                      accountName: account['account_name'],
                                      isSelected:
                                          selectedAccountId == account['id'],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                ///Seleted Category===========================
                Container(
                  decoration: BoxDecoration(
                    color: secondaryBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Consumer<CategoryProvider>(
                    builder: (context, provider, child) {
                      final incomeCategories = provider.getByType("income");

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.category_outlined),
                                const SizedBox(width: 5),

                                uiHelper.CustomText(
                                  text: AppLocalizations.of(context)!.category_select,
                                  fontSize: 16,
                                  fontweight: FontWeight.bold,
                                  context: context,
                                ),

                                const Spacer(),

                                uiHelper.CustomText(
                                  text: selectedCategoryId == null
                                      ? "Select"
                                      : incomeCategories
                                            .firstWhere(
                                              (c) => c.id == selectedCategoryId,
                                            )
                                            .categoryName,
                                  fontSize: 14,
                                  context: context,
                                ),
                              ],
                            ),
                          ),

                          if (incomeCategories.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("No Income Categories Found"),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: incomeCategories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.75,
                                  ),
                              itemBuilder: (context, index) {
                                final category = incomeCategories[index];

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryId = category.id;
                                    });
                                  },
                                  child: AccountAndCategoryCard(
                                    accountName: category.categoryName,
                                    isSelected: selectedCategoryId == category.id,
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                ///Button===========================
                uiHelper.customButton(
                  callback: () async {

                    if (selectedAccountId == null ||
                        selectedCategoryId == null ||
                        AmountController.text.isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Select account, category & enter amount")),
                      );
                      return;
                    }

                    double amount = double.tryParse(AmountController.text) ?? 0.0;

                    // 1️⃣ Save Transaction
                    await context.read<TransactionProvider>().addIncome(
                      amount,
                      desController.text,
                      selectedAccountId!,
                      selectedCategoryId!,
                      selectedDateTime,
                    );

                    // 2️⃣ Update Account Balance
                    await context
                        .read<AccountProvider>()
                        .updateAccountBalance(selectedAccountId!, amount);

                    Navigator.pop(context);
                  },
                  buttonname: AppLocalizations.of(context)!.save_button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container Description(Color secondaryBg) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryBg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.edit_note, size: 30),

            Expanded(
              child: uiHelper.customTextField(
                controller: desController,
                text: AppLocalizations.of(context)!.add_description,
                tohide: false,
                textinputtype: TextInputType.text,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Pick Date And Time==========================
  Future<void> _pickDateTime() async {
    // Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Pick Time
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }
}
