import 'package:trip_planner/entities/entity_settings.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/shared/errors/error_settings.dart';

/// Interface for managing stored settings.
abstract class SettingsRepository {
  /// Returns the saved language or the first supported device language.
  /// Falls back to English when no device language is supported.
  Future<Result<AppLanguage, SettingsError>> getLanguage();

  /// Returns the saved theme, defaulting to the system theme.
  Future<Result<AppTheme, SettingsError>> getTheme();

  /// Saves the selected language.
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language);

  /// Saves the selected theme.
  Future<Result<void, SettingsError>> setTheme(AppTheme theme);
}

/// Interface for managing settings actions.
abstract class SettingsUseCase {
  /// Returns the saved language or the first supported device language.
  /// Falls back to English when no device language is supported.
  Future<Result<AppLanguage, SettingsError>> getLanguage();

  /// Returns the saved theme, defaulting to the system theme.
  Future<Result<AppTheme, SettingsError>> getTheme();

  /// Saves the selected language.
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language);

  /// Saves the selected theme.
  Future<Result<void, SettingsError>> setTheme(AppTheme theme);
}
