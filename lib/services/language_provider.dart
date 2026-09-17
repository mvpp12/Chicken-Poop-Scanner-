import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _languageKey = 'selected_language';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_languageKey);

    if (languageCode != null &&
        (languageCode == 'en' || languageCode == 'tl')) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLanguage(Locale locale) async {
    if (locale.languageCode != 'en' && locale.languageCode != 'tl') {
      return;
    }

    if (_locale == locale) {
      return;
    }

    _locale = locale;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, locale.languageCode);
  }
}
