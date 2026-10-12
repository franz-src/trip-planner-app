import 'package:trip_planner/shared/errors/error_app_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';

/// Interface to manage user actions.
abstract class AppUserRepository {
  /// Returns the current application user information.
  Future<Result<AppUser?, AppUserError>> getUserInformation();

  /// Updates profile data while preserving the password hash.
  Future<Result<AppUser, AppUserError>> updateUser(AppUser user);

  /// Deletes an account, its trips, and its stored session.
  Future<Result<void, AppUserError>> deleteUser(int id);
}

/// Interface to manage user actions.
abstract class AppUserUseCase {
  /// Returns the current application user information.
  Future<Result<AppUser?, AppUserError>> getUserInformation();

  /// Validates and updates the current user's profile.
  Future<Result<AppUser, AppUserError>> updateUser(AppUser user);

  /// Deletes the current account and its data.
  Future<Result<void, AppUserError>> deleteUser(int id);
}
