import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/modules/auth/auth_spec.dart';
import 'package:trip_planner/shared/validations/validation_auth.dart';

AuthUseCase newAuthUseCase(AuthRepository authRepository) {
  return _AuthUseCase(authRepository);
}

class _AuthUseCase implements AuthUseCase {
  const _AuthUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<void, AuthError>> logout() async {
    return await _authRepository.logout();
  }

  @override
  Future<Result<AppUser, AuthError>> attemptLogin(
    UserCredentials credentials,
  ) async {
    final error = AuthRules.validateLogin(credentials);
    if (error != null) {
      return Result.failure(AuthError.invalidCredentials);
    }

    final userResult = await _authRepository.getUserByEmail(credentials.email);
    switch (userResult) {
      case Success(:final value):
        if (value == null) {
          return Result.failure(AuthError.invalidCredentials);
        }

      case Failure(:final error):
        return Result.failure(error);
    }

    return await _authRepository.attemptLogin(credentials);
  }

  @override
  Future<Result<void, AuthError>> attemptRegister(
    UserCredentials credentials,
  ) async {
    final error = AuthRules.validateRegister(credentials);
    if (error != null) {
      return Result.failure(error);
    }

    final userResult = await _authRepository.getUserByEmail(credentials.email);
    switch (userResult) {
      case Success(:final value):
        if (value != null) {
          return Result.failure(AuthError.emailAlreadyRegistered);
        }

      case Failure(:final error):
        return Result.failure(error);
    }

    return await _authRepository.attemptRegister(credentials);
  }
}
