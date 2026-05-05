import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/core/appscolors.dart';
import 'package:takamanager/features/profile/viewmodels/settings_provider.dart';
import 'package:takamanager/features/splash_screen.dart';

import 'l10n/app_localizations.dart';

class TakaManager extends StatefulWidget {
  const TakaManager({super.key});

  @override
  State<TakaManager> createState() => _TakaManagerState();
}

class _TakaManagerState extends State<TakaManager> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    if (settingsProvider.isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('bn'), // Bangla
        ],
        locale: settingsProvider.locale,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        themeMode: settingsProvider.themeMode,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppsColors.backgroundColor,
          primaryColor: AppsColors.primary,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppsColors.backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: AppsColors.primary),
            titleTextStyle: TextStyle(color: AppsColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: AppsColors.primary,
            unselectedItemColor: Colors.grey,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: AppsColors.primary,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1E1E1E),
            selectedItemColor: AppsColors.primary,
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
