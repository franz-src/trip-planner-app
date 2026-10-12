import 'package:trip_planner/shared/errors/error_app_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/modules/app_user/app_user_spec.dart';

import '../../entities/entity_user.dart';

AppUserUseCase newAppUserUseCase(AppUserRepository appUserRepository) {
  return _AppUserUseCase(appUserRepository);
}

class _AppUserUseCase implements AppUserUseCase {
  const _AppUserUseCase(this._appUserRepository);

  final AppUserRepository _appUserRepository;

  @override
  Future<Result<AppUser, AppUserError>> updateUser(AppUser user) async {
    if (user.name.trim().isEmpty) {
      return Result.failure(AppUserError.nameRequired);
    }

    if (user.email.trim().isEmpty) {
      return Result.failure(AppUserError.emailRequired);
    }

    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(user.email)) {
      return Result.failure(AppUserError.invalidEmail);
    }

    return await _appUserRepository.updateUser(user);
  }

  @override
  Future<Result<void, AppUserError>> deleteUser(int id) async {
    return await _appUserRepository.deleteUser(id);
  }

  @override
  Future<Result<AppUser?, AppUserError>> getUserInformation() async {
    return await _appUserRepository.getUserInformation();
  }
}
