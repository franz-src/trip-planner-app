import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_planner/shared/constants/constant_storage_keys.dart';
import 'package:trip_planner/shared/errors/error_app_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/modules/app_user/app_user_spec.dart';
import 'package:trip_planner/infrastructure/database/database.dart';

AppUserRepository newAppUserRepository(
  FlutterSecureStorage storage,
  NewTripPlannerDatabase database,
) {
  return _AppUserRepository(storage, database);
}

class _AppUserRepository implements AppUserRepository {
  const _AppUserRepository(this._storage, this._database);

  final FlutterSecureStorage _storage;
  final NewTripPlannerDatabase _database;

  @override
  Future<Result<AppUser, AppUserError>> updateUser(AppUser user) async {
    try {
      final session = await getUserInformation();
      switch (session) {
        case Success(:final value):
          if (value == null || value.id != user.id) {
            return Result.failure(AppUserError.unexpected);
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
          return Result<AppUser, AppUserError>.failure(
            AppUserError.emailAlreadyRegistered,
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
          key: StorageKeys.appUserStorageKey,
          value: jsonEncode(user.toJSON()),
        );

        return Result<AppUser, AppUserError>.success(user);
      });
    } catch (e) {
      return Result.failure(AppUserError.unexpected);
    }
  }

  @override
  Future<Result<void, AppUserError>> deleteUser(int id) async {
    try {
      final session = await getUserInformation();
      switch (session) {
        case Success(:final value):
          if (value == null || value.id != id) {
            return Result.failure(AppUserError.unexpected);
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

        await _storage.delete(key: StorageKeys.appUserStorageKey);
      });

      return Result.success(null);
    } catch (e) {
      return Result.failure(AppUserError.unexpected);
    }
  }

  @override
  Future<Result<AppUser?, AppUserError>> getUserInformation() async {
    try {
      final user = await _storage.read(key: StorageKeys.appUserStorageKey);
      if (user == null) {
        return Result.success(null);
      }

      final userFromJSON = AppUser.fromJSON(jsonDecode(user));
      return Result.success(userFromJSON);
    } catch (e) {
      return Result.failure(AppUserError.unexpected);
    }
  }
}
