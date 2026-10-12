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
  Future<Result<AppUser?, AppUserError>> getUserInformation() async {
    return await _appUserRepository.getUserInformation();
  }
}
