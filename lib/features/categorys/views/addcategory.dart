import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/core/appscolors.dart';
import 'package:takamanager/l10n/app_localizations.dart';
import '../../uihelper.dart';
import '../viewmodels/category_provider.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {

  TextEditingController enterCategoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 5,
          title: uiHelper.CustomText(
            text: AppLocalizations.of(context)!.add_category,
            fontSize: 24,
            fontweight: FontWeight.bold,
            context: context,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),

            // 🔥 Rounded TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppsColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs:  [
                  Tab(text: AppLocalizations.of(context)!.income),
                  Tab(text:AppLocalizations.of(context)!.expense),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  buildCategoryForm(AppLocalizations.of(context)!.income_add_cat, "income"),
                  buildCategoryForm(AppLocalizations.of(context)!.expense_add_cat, "expense"),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryForm(String title, String type) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          uiHelper.CustomText(
            text: title,
            fontSize: 22,
            fontfamily: "bold",
            color: AppsColors.primary,
            context: context,
          ),
          const SizedBox(height: 15),

          uiHelper.customTextFieldCommon(
            controller: enterCategoryNameController,
            text: "Enter Category Name",
            labelText: AppLocalizations.of(context)!.category_name,
            tohide: false,
            textinputtype: TextInputType.text,
            context: context,
          ),

          const SizedBox(height: 15),

          uiHelper.customTextFieldCommon(
            controller: categoryDescriptionController,
            text: "Enter Description",
            labelText: AppLocalizations.of(context)!.category_des,
            tohide: false,
            textinputtype: TextInputType.text,
            context: context,
          ),

          const SizedBox(height: 25),

          uiHelper.customButton(
            callback: () async {

              final name = enterCategoryNameController.text.trim();
              final desc = categoryDescriptionController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Category name required")),
                );
                return;
              }

              await Provider.of<CategoryProvider>(context, listen: false)
                  .addCategory(name, desc, type);

              // Clear Field
              enterCategoryNameController.clear();
              categoryDescriptionController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Category Added Successfully")),
              );


              Navigator.pop(context);

            },
            buttonname: AppLocalizations.of(context)!.save_category,
          ),
        ],
      ),
    );

  }

  @override
  void dispose() {
    enterCategoryNameController.dispose();
    categoryDescriptionController.dispose();
    super.dispose();
  }

}
