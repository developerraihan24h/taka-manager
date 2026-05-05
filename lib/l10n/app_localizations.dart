import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appname.
  ///
  /// In en, this message translates to:
  /// **'Taka Manager'**
  String get appname;

  /// No description provided for @bottom_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottom_home;

  /// No description provided for @bottom_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get bottom_account;

  /// No description provided for @bottom_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get bottom_category;

  /// No description provided for @bottom_reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get bottom_reports;

  /// No description provided for @welcome_text.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back '**
  String get welcome_text;

  /// No description provided for @total_balance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get total_balance;

  /// No description provided for @total_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get total_expense;

  /// No description provided for @total_income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get total_income;

  /// No description provided for @recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recent_transactions;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get see_all;

  /// No description provided for @trend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get trend;

  /// No description provided for @account_details.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get account_details;

  /// No description provided for @transaction_type.
  ///
  /// In en, this message translates to:
  /// **'Choose Transaction Type'**
  String get transaction_type;

  /// No description provided for @add_income.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get add_income;

  /// No description provided for @add_expense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get add_expense;

  /// No description provided for @add_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get add_amount;

  /// No description provided for @add_description.
  ///
  /// In en, this message translates to:
  /// **'Write Something'**
  String get add_description;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Time and date'**
  String get date;

  /// No description provided for @account_select.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_select;

  /// No description provided for @category_select.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category_select;

  /// No description provided for @save_button.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get save_button;

  /// No description provided for @add_account.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get add_account;

  /// No description provided for @update_account.
  ///
  /// In en, this message translates to:
  /// **'Update Account'**
  String get update_account;

  /// No description provided for @account_name.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get account_name;

  /// No description provided for @your_name.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get your_name;

  /// No description provided for @enter_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enter_amount;

  /// No description provided for @last_digit.
  ///
  /// In en, this message translates to:
  /// **'Last 4 Digit'**
  String get last_digit;

  /// No description provided for @save_account.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get save_account;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @categoris.
  ///
  /// In en, this message translates to:
  /// **'Categoris'**
  String get categoris;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @income_add_cat.
  ///
  /// In en, this message translates to:
  /// **'Income Category Add'**
  String get income_add_cat;

  /// No description provided for @expense_add_cat.
  ///
  /// In en, this message translates to:
  /// **'Expense Category Add'**
  String get expense_add_cat;

  /// No description provided for @category_name.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get category_name;

  /// No description provided for @category_des.
  ///
  /// In en, this message translates to:
  /// **'Category Description'**
  String get category_des;

  /// No description provided for @save_category.
  ///
  /// In en, this message translates to:
  /// **'Save Category'**
  String get save_category;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// No description provided for @last_month_inocme.
  ///
  /// In en, this message translates to:
  /// **'Last Month Income'**
  String get last_month_inocme;

  /// No description provided for @last_month_expense.
  ///
  /// In en, this message translates to:
  /// **'Last Month Expense'**
  String get last_month_expense;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
