import 'package:flutter/material.dart';
import 'package:takamanager/core/appscolors.dart';
import 'package:takamanager/features/accounts/views/accounts_page.dart';
import 'package:takamanager/features/categorys/views/categoris_page.dart';
import 'package:takamanager/features/home/views/home.dart';
import 'package:takamanager/features/reports/views/report_page.dart';
import 'package:takamanager/l10n/app_localizations.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int currentIndex = 0;
  List<Widget> pages = [Home(), AccountsPage(), CategorisPage(), ReportPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppsColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.bottom_home),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: AppLocalizations.of(context)!.bottom_account),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: AppLocalizations.of(context)!.bottom_category,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: AppLocalizations.of(context)!.bottom_reports),
        ],
      ),

      body: IndexedStack(children: pages, index: currentIndex),
    );
  }
}
