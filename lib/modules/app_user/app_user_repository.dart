import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_planner/shared/constants/constant_storage_keys.dart';
import 'package:trip_planner/shared/errors/error_app_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_user.dart';
import 'package:trip_planner/modules/app_user/app_user_spec.dart';

AppUserRepository newAppUserRepository(FlutterSecureStorage storage) {
  return _AppUserRepository(storage);
}

class _AppUserRepository implements AppUserRepository {
  const _AppUserRepository(this._storage);

  final FlutterSecureStorage _storage;

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
