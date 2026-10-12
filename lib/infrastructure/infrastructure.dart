import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/infrastructure/database/database.dart';
import 'package:trip_planner/modules/user/user_repository.dart';
import 'package:trip_planner/modules/user/user_spec.dart';
import 'package:trip_planner/modules/user/user_use_case.dart';
import 'package:trip_planner/modules/auth/auth_repository.dart';
import 'package:trip_planner/modules/auth/auth_spec.dart';
import 'package:trip_planner/modules/auth/auth_use_case.dart';
import 'package:trip_planner/modules/settings/settings_repository.dart';
import 'package:trip_planner/modules/settings/settings_spec.dart';
import 'package:trip_planner/modules/settings/settings_use_case.dart';
import 'package:trip_planner/modules/trip/trip_repository.dart';
import 'package:trip_planner/modules/trip/trip_spec.dart';
import 'package:trip_planner/modules/trip/trip_use_case.dart';
import 'package:trip_planner/modules/person/person_spec.dart';
import 'package:trip_planner/modules/person/person_use_case.dart';
import 'package:trip_planner/modules/stop/stop_spec.dart';
import 'package:trip_planner/modules/stop/stop_repository.dart';
import 'package:trip_planner/modules/stop/stop_use_case.dart';
import 'package:trip_planner/modules/search/search_spec.dart';
import 'package:trip_planner/modules/search/search_repository.dart';
import 'package:trip_planner/modules/search/search_use_case.dart';

/// Global instance for authentication use case.
late final AuthUseCase authUseCase;

/// Global instance for user use case.
late final UserUseCase userUseCase;

/// Global instance for settings use case.
late final SettingsUseCase settingsUseCase;

/// Global instance for trip use case.
late final TripUseCase tripUseCase;

/// Global instance for travel group use case.
late final PersonUseCase personUseCase;

/// Global instance for itinerary stop use case.
late final StopUseCase stopUseCase;

/// Global instance for destination search use case.
late final SearchUseCase searchUseCase;

Future<void>? _initialization;

/// Initializes the application use cases once, allowing failed attempts to retry.
Future<void> initialize() => _initialization ??= _initialize().catchError((
  Object error,
  StackTrace stack,
) {
  _initialization = null;
  Error.throwWithStackTrace(error, stack);
});

Future<void> _initialize() async {
  // Database
  final database = TripPlannerDatabase();

  // Storage
  final storage = FlutterSecureStorage();
  final preferences = await SharedPreferences.getInstance();

  // Repositories
  final authRepository = newAuthRepository(database, storage);
  final userRepository = newUserRepository(storage, database);
  final settingsRepository = newSettingsRepository(preferences);
  final tripRepository = newTripRepository(database);

  // Use cases
  authUseCase = newAuthUseCase(authRepository);
  userUseCase = newUserUseCase(userRepository);
  settingsUseCase = newSettingsUseCase(settingsRepository);
  tripUseCase = newTripUseCase(tripRepository);
  personUseCase = newPersonUseCase();
  stopUseCase = newStopUseCase(newStopRepository());
  searchUseCase = newSearchUseCase(newSearchRepository());
}
