import 'package:trip_planner/entities/entity_settings.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/modules/settings/settings_spec.dart';
import 'package:trip_planner/shared/errors/error_settings.dart';

SettingsUseCase newSettingsUseCase(SettingsRepository settingsRepository) {
  return _SettingsUseCase(settingsRepository);
}

class _SettingsUseCase implements SettingsUseCase {
  const _SettingsUseCase(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<AppLanguage, SettingsError>> getLanguage() async {
    return await _settingsRepository.getLanguage();
  }

  @override
  Future<Result<AppTheme, SettingsError>> getTheme() async {
    return await _settingsRepository.getTheme();
  }

  @override
  Future<Result<void, SettingsError>> setLanguage(AppLanguage language) async {
    return await _settingsRepository.setLanguage(language);
  }

  @override
  Future<Result<void, SettingsError>> setTheme(AppTheme theme) async {
    return await _settingsRepository.setTheme(theme);
  }
}
