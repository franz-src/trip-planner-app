import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_settings.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/shared/errors/error_settings.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/shared/errors/error_app_user.dart';

/// Represents the state for the application.
class AppState with ChangeNotifier {
  /// Default constructor.
  AppState() {
    _init();
  }

  AppUser? _appUser;
  var _themeMode = AppTheme.system.toThemeMode();
  var _locale = AppLanguage.fromLocales(
    PlatformDispatcher.instance.locales,
  ).toLocale();
  var _loading = false;

  /// Represents the current application user.
  AppUser? get appUser => _appUser;

  /// Represents the selected theme mode for the application.
  ThemeMode get themeMode => _themeMode;

  /// Represents the selected language for the application.
  Locale get locale => _locale;

  /// Defines if the state is loading or not.
  bool get loading => _loading;

  /// Restores the current secure session after authentication.
  Future<Result<AppUser?, AppUserError>> refreshUser() async {
    final result = await appUserUseCase.getUserInformation();
    if (result case Success(:final value)) {
      _appUser = value;
      notifyListeners();
    }

    return result;
  }

  /// Persists and applies a language after a successful save.
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language) async {
    final result = await settingsUseCase.setLanguage(language);
    if (result is Success<void, SettingsError>) {
      _locale = language.toLocale();
      notifyListeners();
    }

    return result;
  }

  /// Persists and applies a theme after a successful save.
  Future<Result<void, SettingsError>> setTheme(AppTheme theme) async {
    final result = await settingsUseCase.setTheme(theme);
    if (result is Success<void, SettingsError>) {
      _themeMode = theme.toThemeMode();
      notifyListeners();
    }

    return result;
  }

  /// Updates the current profile through the application user module.
  Future<Result<AppUser, AppUserError>> updateUser(AppUser user) async {
    final result = await appUserUseCase.updateUser(user);
    if (result case Success(:final value)) {
      _appUser = value;
      notifyListeners();
    }

    return result;
  }

  /// Ends the secure session and clears the in-memory user on success.
  Future<Result<void, AuthError>> logout() async {
    final result = await authUseCase.logout();
    if (result is Success<void, AuthError>) {
      _appUser = null;
      notifyListeners();
    }

    return result;
  }

  /// Deletes the current account and clears the in-memory user on success.
  Future<Result<void, AppUserError>> deleteUser() async {
    final user = _appUser;
    if (user == null) {
      return Result.failure(AppUserError.unexpected);
    }

    final result = await appUserUseCase.deleteUser(user.id);
    if (result is Success<void, AppUserError>) {
      _appUser = null;
      notifyListeners();
    }

    return result;
  }

  /// Initializes the state.
  Future<void> _init() async {
    _loading = true;
    notifyListeners();

    final userResult = await appUserUseCase.getUserInformation();
    _appUser = switch (userResult) {
      Success(:final value) => value,
      Failure() => null,
    };

    final themeResult = await settingsUseCase.getTheme();
    _themeMode = switch (themeResult) {
      Success(:final value) => value.toThemeMode(),
      Failure() => AppTheme.system.toThemeMode(),
    };

    final languageResult = await settingsUseCase.getLanguage();
    _locale = switch (languageResult) {
      Success(:final value) => value.toLocale(),
      Failure() => _locale,
    };

    _loading = false;
    notifyListeners();
  }
}
