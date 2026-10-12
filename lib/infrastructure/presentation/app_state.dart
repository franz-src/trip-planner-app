import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';

/// Represents the state for the application.
class AppState with ChangeNotifier {
  /// Default constructor.
  AppState() {
    _init();
  }

  AppUser? _appUser;
  var _themeMode = ThemeMode.system;
  var _locale = Locale('EN');
  var _loading = false;

  /// Represents the current application user.
  AppUser? get appUser => _appUser;

  /// Represents the selected theme mode for the application.
  ThemeMode get themeMode => _themeMode;

  /// Represents the selected language for the application.
  Locale get locale => _locale;

  /// Defines if the state is loading or not.
  bool get loading => _loading;

  /// Initializes the state.
  Future<void> _init() async {
    _loading = true;
    notifyListeners();

    final userResult = await appUserUseCase.getUserInformation();
    _appUser = switch (userResult) {
      Success(:final value) => value,
      Failure() => null,
    };

    _themeMode = await settingsUseCase.getTheme();
    _locale = await settingsUseCase.getLanguage();

    _loading = false;
    notifyListeners();
  }
}
