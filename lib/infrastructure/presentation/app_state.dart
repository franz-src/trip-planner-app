import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_settings.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/shared/errors/error_settings.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/shared/errors/error_user.dart';

/// Represents the state for the application.
class AppState with ChangeNotifier {
  /// Default constructor.
  AppState() {
    _initialization = _init();
  }

  late Future<void> _initialization;
  bool _disposed = false;
  int _sessionRequest = 0;
  int _tripRevision = 0;
  UserError? _initializationError;

  User? _user;
  var _themeMode = AppTheme.system.toThemeMode();
  var _locale = AppLanguage.fromLocales(
    PlatformDispatcher.instance.locales,
  ).toLocale();
  var _loading = true;

  /// Represents the current application user.
  User? get user => _user;

  /// Represents the selected theme mode for the application.
  ThemeMode get themeMode => _themeMode;

  /// Represents the selected language for the application.
  Locale get locale => _locale;

  /// Defines if the state is loading or not.
  bool get loading => _loading;

  /// Failure encountered while restoring the initial session.
  UserError? get initializationError => _initializationError;

  /// Revision of saved trips, used to refresh cached navigation tabs.
  int get tripRevision => _tripRevision;

  /// Signals that saved trip data has changed.
  void markTripsChanged() {
    _tripRevision++;
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Retries initial session and preference restoration.
  Future<void> retryInitialization() {
    if (_loading) {
      return _initialization;
    }

    _initialization = _init();

    return _initialization;
  }

  /// Applies a user whose login has already persisted the secure session.
  void acceptUser(User user) {
    if (_disposed) {
      return;
    }

    _sessionRequest++;
    _user = user;
    _initializationError = null;
    notifyListeners();
  }

  /// Restores the current secure session after authentication.
  Future<Result<User?, UserError>> refreshUser() async {
    await _initialization;
    final request = _sessionRequest;
    final result = await userUseCase.getUserInformation();
    if (_disposed || request != _sessionRequest) {
      return Result.failure(UserError.unexpected);
    }

    if (result case Success(:final value)) {
      _user = value;
      notifyListeners();
    }

    return result;
  }

  /// Persists and applies a language after a successful save.
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language) async {
    final result = await settingsUseCase.setLanguage(language);
    if (!_disposed && result is Success<void, SettingsError>) {
      _locale = language.toLocale();
      notifyListeners();
    }

    return result;
  }

  /// Persists and applies a theme after a successful save.
  Future<Result<void, SettingsError>> setTheme(AppTheme theme) async {
    final result = await settingsUseCase.setTheme(theme);
    if (!_disposed && result is Success<void, SettingsError>) {
      _themeMode = theme.toThemeMode();
      notifyListeners();
    }

    return result;
  }

  /// Updates the current profile through the application user module.
  Future<Result<User, UserError>> updateUser(User user) async {
    if (_user?.id != user.id) {
      return Result.failure(UserError.unexpected);
    }

    final result = await userUseCase.updateUser(user);
    if (!_disposed &&
        _user?.id == user.id &&
        result is Success<User, UserError>) {
      final value = result.value;
      _sessionRequest++;
      _user = value;
      notifyListeners();
    }

    return result;
  }

  /// Ends the secure session and clears the in-memory user on success.
  Future<Result<void, AuthError>> logout() async {
    final result = await authUseCase.logout();
    if (!_disposed && result is Success<void, AuthError>) {
      _sessionRequest++;
      _user = null;
      notifyListeners();
    }

    return result;
  }

  /// Deletes the current account and clears the in-memory user on success.
  Future<Result<void, UserError>> deleteUser() async {
    final user = _user;
    if (user == null) {
      return Result.failure(UserError.unexpected);
    }

    final result = await userUseCase.deleteUser(user.id);
    if (!_disposed && result is Success<void, UserError>) {
      _sessionRequest++;
      _user = null;
      notifyListeners();
    }

    return result;
  }

  /// Initializes session and preferences before protected routes can open.
  Future<void> _init() async {
    _loading = true;
    _initializationError = null;
    if (!_disposed) {
      notifyListeners();
    }

    try {
      final userResult = await userUseCase.getUserInformation();
      if (_disposed) {
        return;
      }

      switch (userResult) {
        case Success(:final value):
          _user = value;
        case Failure(:final error):
          _initializationError = error;
      }

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
    } catch (e) {
      _initializationError = UserError.unexpected;
    } finally {
      _loading = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
