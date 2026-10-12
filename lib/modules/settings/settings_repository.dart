import 'dart:ui' show PlatformDispatcher;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_settings.dart';
import 'package:trip_planner/modules/settings/settings_spec.dart';
import 'package:trip_planner/shared/constants/constant_storage_keys.dart';
import 'package:trip_planner/shared/errors/error_settings.dart';

SettingsRepository newSettingsRepository(SharedPreferences preferences) {
  return _SettingsRepository(preferences);
}

class _SettingsRepository implements SettingsRepository {
  const _SettingsRepository(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<Result<AppLanguage, SettingsError>> getLanguage() async {
    try {
      final code = _preferences.getString(StorageKeys.languageStorageKey);
      if (code == null) {
        final language = AppLanguage.fromLocales(
          PlatformDispatcher.instance.locales,
        );

        return Result.success(language);
      }

      return Result.success(AppLanguage.fromCode(code));
    } catch (e) {
      return Result.failure(SettingsError.unexpected);
    }
  }

  @override
  Future<Result<AppTheme, SettingsError>> getTheme() async {
    try {
      final code = _preferences.getString(StorageKeys.themeStorageKey);
      if (code == null) {
        return Result.success(AppTheme.system);
      }

      return Result.success(AppTheme.fromCode(code));
    } catch (e) {
      return Result.failure(SettingsError.unexpected);
    }
  }

  @override
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language) async {
    try {
      final saved = await _preferences.setString(
        StorageKeys.languageStorageKey,
        language.code,
      );
      if (!saved) {
        return Result.failure(SettingsError.unexpected);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(SettingsError.unexpected);
    }
  }

  @override
  Future<Result<void, SettingsError>> setTheme(AppTheme theme) async {
    try {
      final saved = await _preferences.setString(
        StorageKeys.themeStorageKey,
        theme.code,
      );
      if (!saved) {
        return Result.failure(SettingsError.unexpected);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(SettingsError.unexpected);
    }
  }
}
