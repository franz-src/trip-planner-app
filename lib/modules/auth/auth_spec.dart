import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';

/// Represents a interface for managing auth database actions.
abstract class AuthRepository {
  /// Finds a user by email; a missing account is a successful null result.
  Future<Result<AppUser?, AuthError>> getUserByEmail(String email);

  /// A user-attempt to login in the app.
  Future<Result<AppUser, AuthError>> attemptLogin(UserCredentials credentials);

  /// A user-attempt to create a new account in the app.
  Future<Result<void, AuthError>> attemptRegister(UserCredentials credentials);
}

/// Represents a interface for managing auth actions.
abstract class AuthUseCase {
  /// A user-attempt to login in the app.
  Future<Result<AppUser, AuthError>> attemptLogin(UserCredentials credentials);

  /// A user-attempt to create a new account in the app.
  Future<Result<void, AuthError>> attemptRegister(UserCredentials credentials);
}
