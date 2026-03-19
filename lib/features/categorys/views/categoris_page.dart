import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/features/categorys/views/addcategory.dart';
import 'package:takamanager/features/categorys/widgets/category_card.dart';
import 'package:takamanager/l10n/app_localizations.dart';

import '../../../core/appscolors.dart';
import '../../transaction/viewmodels/transaction_provider.dart';
import '../viewmodels/category_provider.dart';

class CategorisPage extends StatefulWidget {
  const CategorisPage({super.key});

  @override
  State<CategorisPage> createState() => _CategorisPageState();
}

class _CategorisPageState extends State<CategorisPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).LoadCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,

          title: Row(
            children: [
              Icon(Icons.category, color: AppsColors.primary),
              const SizedBox(width: 10),

              Text(
                AppLocalizations.of(context)!.categoris,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "bold",
                  color: AppsColors.primary,
                ),
              ),
            ],
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey.shade200, height: 1),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),

            // 🔥 Custom Rounded TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                dividerColor: Colors.transparent, // ✅ removes top line
                indicator: BoxDecoration(
                  color: const Color(0xff2E5F77),
                  borderRadius: BorderRadius.circular(30),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.expense),
                  Tab(text: AppLocalizations.of(context)!.income),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  //Expense Tab=================================
                  Consumer2<CategoryProvider, TransactionProvider>(
                    builder: (context, catProvider, txnProvider, child) {
                      final expenseList = catProvider.getByType("expense");

                      return FutureBuilder(
                        future: txnProvider.getCategoryStats("expense"),
                        builder: (context, snapshot) {
                          Map<int, Map<String, dynamic>> stats = {};

                          if (snapshot.hasData) {
                            stats = snapshot.data!;
                          }

                          return ListView.builder(
                            itemCount: expenseList.length,
                            itemBuilder: (context, index) {
                              final category = expenseList[index];

                              final data =
                                  stats[category.id] ??
                                  {"count": 0, "amount": 0};

                              return InkWell(
                                onTap: () {
                                  showDeleteDialog(context, category.id!);
                                },
                                child: CategoryCard(
                                  categoryName: category.categoryName,
                                  transactionCount: data["count"],
                                  totalAmount: data["amount"].toDouble(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  ///income=============================
                  Consumer2<CategoryProvider, TransactionProvider>(
                    builder: (context, catProvider, txnProvider, child) {
                      final incomeList = catProvider.getByType("income");

                      return FutureBuilder(
                        future: txnProvider.getCategoryStats("income"),
                        builder: (context, snapshot) {
                          Map<int, Map<String, dynamic>> stats = {};

                          if (snapshot.hasData) {
                            stats = snapshot.data!;
                          }

                          if (incomeList.isEmpty) {
                            return const Center(
                              child: Text("No Income Category"),
                            );
                          }

                          return ListView.builder(
                            itemCount: incomeList.length,
                            itemBuilder: (context, index) {
                              final category = incomeList[index];

                              final data =
                                  stats[category.id] ??
                                  {"count": 0, "amount": 0};

                              return InkWell(
                                onTap: () {
                                  showDeleteDialog(context, category.id!);
                                },
                                child: CategoryCard(
                                  categoryName: category.categoryName,
                                  transactionCount: data["count"],
                                  totalAmount: (data["amount"] as num).toDouble(),
                                ),
                              );
                            },
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

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppsColors.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Addcategory();
                },
              ),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int categoryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Delete Category"),
          content: const Text("Are you sure you want to delete this category?"),
          actions: [

            /// Cancel
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            /// Delete
            TextButton(
              onPressed: () {
                Provider.of<CategoryProvider>(
                  context,
                  listen: false,
                ).deleteCategory(categoryId);

                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
