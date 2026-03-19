import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/app.dart';
import 'package:takamanager/features/accounts/viewmodels/account_provider.dart';
import 'package:takamanager/features/categorys/viewmodels/category_provider.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/features/transaction/viewmodels/transaction_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: TakaManager(),
    ),
  );
}
