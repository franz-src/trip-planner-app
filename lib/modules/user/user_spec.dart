import 'package:trip_planner/shared/errors/error_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';

/// Interface to manage user actions.
abstract class UserRepository {
  /// Returns the current application user information.
  Future<Result<User?, UserError>> getUserInformation();

  /// Updates profile data while preserving the password hash.
  Future<Result<User, UserError>> updateUser(User user);

  /// Deletes an account, its trips, and its stored session.
  Future<Result<void, UserError>> deleteUser(int id);
}

/// Interface to manage user actions.
abstract class UserUseCase {
  /// Returns the current application user information.
  Future<Result<User?, UserError>> getUserInformation();

  /// Validates and updates the current user's profile.
  Future<Result<User, UserError>> updateUser(User user);

  /// Deletes the current account and its data.
  Future<Result<void, UserError>> deleteUser(int id);
}
