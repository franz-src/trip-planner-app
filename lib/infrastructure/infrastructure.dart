import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/infrastructure/database/database.dart';
import 'package:trip_planner/modules/app_user/app_user_repository.dart';
import 'package:trip_planner/modules/app_user/app_user_spec.dart';
import 'package:trip_planner/modules/app_user/app_user_use_case.dart';
import 'package:trip_planner/modules/auth/auth_repository.dart';
import 'package:trip_planner/modules/auth/auth_spec.dart';
import 'package:trip_planner/modules/auth/auth_use_case.dart';
import 'package:trip_planner/modules/settings/settings_repository.dart';
import 'package:trip_planner/modules/settings/settings_spec.dart';
import 'package:trip_planner/modules/settings/settings_use_case.dart';

/// Global instance for authentication use case.
late final AuthUseCase authUseCase;

/// Global instance for app user use case.
late final AppUserUseCase appUserUseCase;

/// Global instance for settings use case.
late final SettingsUseCase settingsUseCase;

/// Initializes the application use cases.
Future<void> initialize() async {
  // Database
  final database = NewTripPlannerDatabase();

  // Storage
  final storage = FlutterSecureStorage();
  final preferences = await SharedPreferences.getInstance();

  // Repositories
  final authRepository = newAuthRepository(database, storage);
  final appUserRepository = newAppUserRepository(storage, database);
  final settingsRepository = newSettingsRepository(preferences);

  // Use cases
  authUseCase = newAuthUseCase(authRepository);
  appUserUseCase = newAppUserUseCase(appUserRepository);
  settingsUseCase = newSettingsUseCase(settingsRepository);
}
