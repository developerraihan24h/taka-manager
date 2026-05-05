import 'package:flutter/material.dart';
import 'package:takamanager/core/dbhelper.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String _currency = '৳';
  String _userName = "";
  String? _profileImagePath;
  bool _isFirstTime = true;
  bool _isLoading = true;
  ThemeMode _themeMode = ThemeMode.light;

  Locale get locale => _locale;
  String get currency => _currency;
  String get userName => _userName;
  String? get profileImagePath => _profileImagePath;
  bool get isFirstTime => _isFirstTime;
  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    var db = await DBHelper.getInstance.getDB();
    List<Map<String, dynamic>> settings = await db.query(DBHelper.TABLE_SETTINGS, where: "id = ?", whereArgs: [1]);

    if (settings.isNotEmpty) {
      var data = settings.first;
      _userName = data['user_name'] ?? "";
      _profileImagePath = data['profile_image_path'];
      _currency = data['currency'] ?? '৳';
      _locale = Locale(data['language_code'] ?? 'en');
      _themeMode = data['theme_mode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
      _isFirstTime = _userName.isEmpty;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setCurrency(String currency) async {
    _currency = currency;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> updateProfile(String name, String? imagePath) async {
    _userName = name;
    _profileImagePath = imagePath;
    _isFirstTime = false;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    var db = await DBHelper.getInstance.getDB();
    await db.update(
      DBHelper.TABLE_SETTINGS,
      {
        'user_name': _userName,
        'profile_image_path': _profileImagePath,
        'currency': _currency,
        'language_code': _locale.languageCode,
        'theme_mode': _themeMode == ThemeMode.dark ? 'dark' : 'light',
      },
      where: "id = ?",
      whereArgs: [1],
    );
  }
}
