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
        theme: ThemeData(
          scaffoldBackgroundColor: AppsColors.backgroundColor,
        ),
      ),
    );
  }
}
