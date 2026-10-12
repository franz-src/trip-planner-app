import 'package:trip_planner/shared/errors/error_app_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';

/// Interface to manage user actions.
abstract class AppUserRepository {
  /// Returns the current application user information.
  Future<Result<AppUser?, AppUserError>> getUserInformation();
}

/// Interface to manage user actions.
abstract class AppUserUseCase {
  /// Returns the current application user information.
  Future<Result<AppUser?, AppUserError>> getUserInformation();
}
