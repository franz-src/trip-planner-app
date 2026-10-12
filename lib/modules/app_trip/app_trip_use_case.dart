import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/modules/app_trip/app_trip_spec.dart';
import 'package:trip_planner/shared/errors/error_app_trip.dart';
import 'package:trip_planner/shared/validations/validation_app_trip.dart';

AppTripUseCase newAppTripUseCase(AppTripRepository appTripRepository) {
  return _AppTripUseCase(appTripRepository);
}

class _AppTripUseCase implements AppTripUseCase {
  const _AppTripUseCase(this._appTripRepository);

  final AppTripRepository _appTripRepository;

  @override
  Future<Result<Trip, AppTripError>> getTrip(int id, int userId) async {
    if (id <= 0 || userId <= 0) {
      return Result.failure(AppTripError.invalidTrip);
    }

    final result = await _appTripRepository.getAllTrips(userId);
    switch (result) {
      case Failure(:final error):
        return Result.failure(error);
      case Success(:final value):
        for (final trip in value) {
          if (trip.id == id) {
            return Result.success(trip);
          }
        }
    }

    return Result.failure(AppTripError.notFound);
  }

  @override
  Future<Result<int, AppTripError>> addTrip(Trip trip) async {
    final error = AppTripRules.validateTrip(trip);
    if (error != null) {
      return Result.failure(error);
    }

    return await _appTripRepository.addTrip(trip);
  }

  @override
  Future<Result<void, AppTripError>> updateTrip(Trip trip) async {
    if (trip.id == null || trip.id! <= 0) {
      return Result.failure(AppTripError.invalidTrip);
    }

    final error = AppTripRules.validateTrip(trip);
    if (error != null) {
      return Result.failure(error);
    }

    return await _appTripRepository.updateTrip(trip);
  }

  @override
  Future<Result<void, AppTripError>> deleteTrip(int id, int userId) async {
    if (id <= 0 || userId <= 0) {
      return Result.failure(AppTripError.invalidTrip);
    }

    return await _appTripRepository.deleteTrip(id, userId);
  }

  @override
  Future<Result<List<Trip>, AppTripError>> getAllTrips(int userId) async {
    if (userId <= 0) {
      return Result.failure(AppTripError.invalidTrip);
    }

    return await _appTripRepository.getAllTrips(userId);
  }
}
