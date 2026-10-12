import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/modules/stop/stop_spec.dart';
import 'package:trip_planner/shared/errors/error_stop.dart';
import 'package:trip_planner/shared/validations/validation_stop.dart';

StopUseCase newStopUseCase(StopRepository repository) =>
    _StopUseCase(repository);

class _StopUseCase implements StopUseCase {
  const _StopUseCase(this._repository);

  final StopRepository _repository;

  @override
  Result<Stop, StopError> validateStop(Stop stop) {
    final error = StopRules.validateStop(stop);
    if (error != null) {
      return Result.failure(error);
    }

    return Result.success(stop);
  }

  @override
  Future<Result<String?, StopError>> getAddressFromCoordinates(
    LatLng position,
  ) async {
    return await _repository.getAddressFromCoordinates(position);
  }

  @override
  Future<Result<List<LatLng>, StopError>> getRoute(List<LatLng> points) async {
    return await _repository.getRoute(points);
  }
}
