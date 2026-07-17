import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_localizations.dart';

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('ar'));

  void setLocale(Locale locale) {
    if (!_isSupported(locale.languageCode)) return;
    state = locale;
  }

  void toggle() => setLocale(
        state.languageCode == 'ar'
            ? const Locale('en')
            : const Locale('ar'),
      );

  bool _isSupported(String code) =>
      AppLocalizations.supported.any((l) => l.languageCode == code);
}

final localeProvider = StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);
