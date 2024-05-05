// filename: locale_provider.dart
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }
}

// L10n class for supported locales
class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ur'),
    const Locale('ar'),
    const Locale('ko'),
    const Locale('de'),
    const Locale('hi'),
    const Locale('zh'),

  ];
}
