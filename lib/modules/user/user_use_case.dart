import 'package:trip_planner/shared/errors/error_user.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/modules/user/user_spec.dart';

import '../../entities/entity_user.dart';

UserUseCase newUserUseCase(UserRepository userRepository) {
  return _UserUseCase(userRepository);
}

class _UserUseCase implements UserUseCase {
  const _UserUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Result<User, UserError>> updateUser(User user) async {
    if (user.name.trim().isEmpty) {
      return Result.failure(UserError.nameRequired);
    }

    if (user.email.trim().isEmpty) {
      return Result.failure(UserError.emailRequired);
    }

    if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(user.email)) {
      return Result.failure(UserError.invalidEmail);
    }

    return await _userRepository.updateUser(user);
  }

  @override
  Future<Result<void, UserError>> deleteUser(int id) async {
    return await _userRepository.deleteUser(id);
  }

  @override
  Future<Result<User?, UserError>> getUserInformation() async {
    return await _userRepository.getUserInformation();
  }
}
