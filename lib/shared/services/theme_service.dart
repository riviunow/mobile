import 'package:flutter/foundation.dart';
import 'package:udetxen/shared/config/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udetxen/shared/constants/pref_keys.dart';

class ThemeService with ChangeNotifier {
  final prefs = getIt<SharedPreferences>();

  void saveThemeMode(bool isDarkMode) {
    prefs.setBool(PrefKeys.theme, isDarkMode);
  }

  void toggleThemeMode() {
    bool currentMode = prefs.getBool(PrefKeys.theme) ?? false;
    prefs.setBool(PrefKeys.theme, !currentMode);
    notifyListeners();
  }

  bool get isDarkMode {
    bool currentMode = prefs.getBool(PrefKeys.theme) ?? false;
    return currentMode;
  }
}
