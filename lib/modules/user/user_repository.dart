import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_planner/shared/constants/constant_storage_keys.dart';
import 'package:trip_planner/shared/errors/error_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/modules/user/user_spec.dart';
import 'package:trip_planner/infrastructure/database/database.dart';

UserRepository newUserRepository(
  FlutterSecureStorage storage,
  TripPlannerDatabase database,
) {
  return _UserRepository(storage, database);
}

class _UserRepository implements UserRepository {
  const _UserRepository(this._storage, this._database);

  final FlutterSecureStorage _storage;
  final TripPlannerDatabase _database;

  @override
  Future<Result<User, UserError>> updateUser(User user) async {
    try {
      final session = await getUserInformation();
      switch (session) {
        case Success(:final value):
          if (value == null || value.id != user.id) {
            return Result.failure(UserError.unexpected);
          }
        case Failure(:final error):
          return Result.failure(error);
      }

      final connection = await _database.connection;
      return await connection.transaction((transaction) async {
        final existing = await transaction.query(
          'users',
          where: 'email = ? AND id != ?',
          whereArgs: [user.email, user.id],
          limit: 1,
        );
        if (existing.isNotEmpty) {
          return Result<User, UserError>.failure(
            UserError.emailAlreadyRegistered,
          );
        }

        final updated = await transaction.update(
          'users',
          {'name': user.name, 'email': user.email},
          where: 'id = ?',
          whereArgs: [user.id],
        );
        if (updated != 1) {
          throw StateError('The current account does not exist');
        }

        await _storage.write(
          key: StorageKeys.userStorageKey,
          value: jsonEncode(user.toJSON()),
        );

        return Result<User, UserError>.success(user);
      });
    } catch (e) {
      return Result.failure(UserError.unexpected);
    }
  }

  @override
  Future<Result<void, UserError>> deleteUser(int id) async {
    try {
      final session = await getUserInformation();
      switch (session) {
        case Success(:final value):
          if (value == null || value.id != id) {
            return Result.failure(UserError.unexpected);
          }
        case Failure(:final error):
          return Result.failure(error);
      }

      final connection = await _database.connection;
      await connection.transaction((transaction) async {
        // Delete child rows explicitly because existing databases may not
        // have SQLite foreign-key enforcement enabled.
        await transaction.delete(
          'user_experiences',
          where:
              'stop_id IN (SELECT stops.id FROM stops JOIN trips '
              'ON stops.trip_id = trips.id WHERE trips.user_id = ?)',
          whereArgs: [id],
        );
        for (final table in ['persons', 'stops']) {
          await transaction.delete(
            table,
            where: 'trip_id IN (SELECT id FROM trips WHERE user_id = ?)',
            whereArgs: [id],
          );
        }
        await transaction.delete(
          'trips',
          where: 'user_id = ?',
          whereArgs: [id],
        );
        final deleted = await transaction.delete(
          'users',
          where: 'id = ?',
          whereArgs: [id],
        );
        if (deleted != 1) {
          throw StateError('The current account does not exist');
        }

        await _storage.delete(key: StorageKeys.userStorageKey);
      });

      return Result.success(null);
    } catch (e) {
      return Result.failure(UserError.unexpected);
    }
  }

  @override
  Future<Result<User?, UserError>> getUserInformation() async {
    try {
      final user = await _storage.read(key: StorageKeys.userStorageKey);
      if (user == null) {
        return Result.success(null);
      }

      final userFromJSON = User.fromJSON(jsonDecode(user));
      return Result.success(userFromJSON);
    } catch (e) {
      return Result.failure(UserError.unexpected);
    }
  }
}
