import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/modules/app_stop/app_stop_spec.dart';
import 'package:trip_planner/shared/errors/error_app_stop.dart';
import 'package:trip_planner/shared/validations/validation_app_stop.dart';

AppStopUseCase newAppStopUseCase(AppStopRepository repository) =>
    _AppStopUseCase(repository);

class _AppStopUseCase implements AppStopUseCase {
  const _AppStopUseCase(this._repository);

  final AppStopRepository _repository;

  @override
  Result<Stop, AppStopError> validateStop(Stop stop) {
    final error = AppStopRules.validateStop(stop);
    if (error != null) {
      return Result.failure(error);
    }

    return Result.success(stop);
  }

  @override
  Future<Result<String?, AppStopError>> getAddressFromCoordinates(
    LatLng position,
  ) async {
    return await _repository.getAddressFromCoordinates(position);
  }

  @override
  Future<Result<List<LatLng>, AppStopError>> getRoute(
    List<LatLng> points,
  ) async {
    return await _repository.getRoute(points);
  }
}
