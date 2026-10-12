import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_settings.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/shared/errors/error_user.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/shared/errors/error_settings.dart';

/// State for preferences and current-account actions.
class SettingsState with ChangeNotifier {
  /// Initializes profile fields from the secure session.
  SettingsState(this._appState) {
    _loadUser();
  }

  final AppState _appState;

  /// Controller for the current user's profile name.
  final TextEditingController controllerName = TextEditingController();

  /// Controller for the current user's profile email.
  final TextEditingController controllerEmail = TextEditingController();

  bool _showLanguage = false;
  bool _showInformation = false;
  bool _loading = true;
  bool _disposed = false;
  UserError? _error;

  /// Whether language choices are visible.
  bool get showLanguage => _showLanguage;

  /// Whether profile fields are visible.
  bool get showInformation => _showInformation;

  /// Whether the current account is still being restored.
  bool get loading => _loading;

  /// A failure encountered while restoring the current profile.
  UserError? get error => _error;

  Future<void> _loadUser() async {
    final result = await _appState.refreshUser();
    if (_disposed) {
      return;
    }

    switch (result) {
      case Success(:final value):
        if (value != null) {
          controllerName.text = value.name;
          controllerEmail.text = value.email;
        }
      case Failure(:final error):
        _error = error;
    }

    _loading = false;
    notifyListeners();
  }

  /// Shows or hides the language choices.
  void toggleLanguage() {
    _showLanguage = !_showLanguage;
    notifyListeners();
  }

  /// Shows or hides profile fields.
  void toggleInformation() {
    _showInformation = !_showInformation;
    notifyListeners();
  }

  /// Saves and applies the selected language.
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language) async {
    _showLanguage = false;
    notifyListeners();

    return await _appState.setLanguage(language);
  }

  /// Saves and applies the selected theme.
  Future<Result<void, SettingsError>> setTheme(AppTheme theme) async {
    return await _appState.setTheme(theme);
  }

  /// Saves the edited name and email without changing the password.
  Future<Result<User, UserError>> updateUser() async {
    final currentUser = _appState.user;
    if (currentUser == null) {
      return Result.failure(UserError.unexpected);
    }

    final user = User(
      id: currentUser.id,
      name: controllerName.text,
      email: controllerEmail.text,
    );

    return await _appState.updateUser(user);
  }

  /// Deletes the current account through the application user module.
  Future<Result<void, UserError>> deleteUser() async {
    return await _appState.deleteUser();
  }

  /// Ends the current session through the authentication module.
  Future<Result<void, AuthError>> logout() async {
    return await _appState.logout();
  }

  @override
  void dispose() {
    _disposed = true;
    controllerName.dispose();
    controllerEmail.dispose();
    super.dispose();
  }
}
