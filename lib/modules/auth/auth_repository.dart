import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_planner/shared/constants/constant_storage_keys.dart';
import 'package:trip_planner/shared/errors/error_auth.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/infrastructure/database/database.dart';
import 'package:trip_planner/modules/auth/auth_spec.dart';

AuthRepository newAuthRepository(
  TripPlannerDatabase database,
  FlutterSecureStorage storage,
) {
  return _AuthRepository(database, storage);
}

class _AuthRepository implements AuthRepository {
  const _AuthRepository(this._database, this._storage);

  final TripPlannerDatabase _database;
  final FlutterSecureStorage _storage;

  @override
  Future<Result<void, AuthError>> logout() async {
    try {
      await _storage.delete(key: StorageKeys.userStorageKey);

      return Result.success(null);
    } catch (e) {
      return Result.failure(AuthError.unexpected);
    }
  }

  @override
  Future<Result<User, AuthError>> attemptLogin(
    UserCredentials credentials,
  ) async {
    try {
      final conn = await _database.connection;

      final users = await conn.query(
        'users',
        where: 'email = ?',
        whereArgs: [credentials.email],
        limit: 1,
      );
      if (users.isEmpty) {
        return Result.failure(AuthError.invalidCredentials);
      }

      final passwordMatch = BCrypt.checkpw(
        credentials.password,
        users.first['password'] as String,
      );
      if (!passwordMatch) {
        return Result.failure(AuthError.invalidCredentials);
      }

      final user = User.fromJSON(users.first);
      await _storage.write(
        key: StorageKeys.userStorageKey,
        value: jsonEncode(user.toJSON()),
      );

      return Result.success(user);
    } catch (e) {
      return Result.failure(AuthError.unexpected);
    }
  }

  @override
  Future<Result<void, AuthError>> attemptRegister(
    UserCredentials credentials,
  ) async {
    try {
      final conn = await _database.connection;

      final passwordHash = BCrypt.hashpw(
        credentials.password,
        BCrypt.gensalt(logRounds: 12),
      );

      final user = credentials.copyWith(password: passwordHash);
      await conn.insert('users', user.toJSON());

      return Result.success(null);
    } catch (e) {
      return Result.failure(AuthError.unexpected);
    }
  }

  @override
  Future<Result<User?, AuthError>> getUserByEmail(String email) async {
    try {
      final conn = await _database.connection;

      final users = await conn.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (users.isEmpty) {
        return Result.success(null);
      }

      return Result.success(User.fromJSON(users.first));
    } catch (e) {
      return Result.failure(AuthError.unexpected);
    }
  }
}
