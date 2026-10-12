import 'package:flutter/material.dart';

/// Supported application languages and their persisted codes.
///
/// Save [code] in preferences and use [toLocale] when configuring Flutter.
/// Use [fromCode] to restore a saved language.
enum AppLanguage {
  /// American English, stored as `en` and mapped to `en_US`.
  english('en', Locale('en', 'US')),

  /// Brazilian Portuguese, stored as `pt` and mapped to `pt_BR`.
  portuguese('pt', Locale('pt', 'BR')),

  /// Spanish from Spain, stored as `es` and mapped to `es_ES`.
  spanish('es', Locale('es', 'ES'));

  /// Associates a persisted language code with its Flutter locale.
  const AppLanguage(this.code, this._locale);

  /// Canonical preference value: `en`, `pt`, or `es`.
  final String code;

  /// Flutter locale associated with this language.
  final Locale _locale;

  /// Converts this language to a Flutter locale.
  Locale toLocale() => _locale;

  /// Selects the first supported language from the device's preferred locales.
  ///
  /// Matches language codes regardless of region (for example, `pt_PT` selects
  /// [portuguese]). Falls back to [english] if the list is empty or none of the
  /// preferred languages is supported by the application.
  static AppLanguage fromLocales(Iterable<Locale> locales) {
    for (final locale in locales) {
      for (final language in values) {
        if (language.code == locale.languageCode) {
          return language;
        }
      }
    }

    return english;
  }

  /// Parses a persisted code, rejecting unsupported languages.
  ///
  /// Accepts exactly `en`, `pt`, or `es`. Throws [FormatException] for any
  /// other value; missing preferences and defaults are handled by the caller.
  static AppLanguage fromCode(String code) {
    return switch (code) {
      'en' => english,
      'pt' => portuguese,
      'es' => spanish,
      _ => throw FormatException('Unsupported language code', code),
    };
  }
}

/// Supported application themes and their persisted codes.
///
/// Save [code] in preferences and use [toThemeMode] when configuring Flutter.
/// Use [fromCode] to restore a saved theme.
enum AppTheme {
  /// Follows the device theme, stored as `system`.
  system('system', ThemeMode.system),

  /// Always uses the light theme, stored as `light`.
  light('light', ThemeMode.light),

  /// Always uses the dark theme, stored as `dark`.
  dark('dark', ThemeMode.dark);

  /// Associates a persisted theme code with its Flutter theme mode.
  const AppTheme(this.code, this._themeMode);

  /// Canonical preference value: `system`, `light`, or `dark`.
  final String code;

  /// Flutter theme mode associated with this theme.
  final ThemeMode _themeMode;

  /// Converts this theme to a Flutter theme mode.
  ThemeMode toThemeMode() => _themeMode;

  /// Parses a persisted code, rejecting unsupported themes.
  ///
  /// Accepts exactly `system`, `light`, or `dark`. Throws [FormatException] for
  /// any other value; missing preferences and defaults are handled by the caller.
  static AppTheme fromCode(String code) {
    return switch (code) {
      'system' => system,
      'light' => light,
      'dark' => dark,
      _ => throw FormatException('Unsupported theme code', code),
    };
  }
}
