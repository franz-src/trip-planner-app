import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/modules/trip/trip_spec.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';
import 'package:trip_planner/shared/validations/validation_trip.dart';

TripUseCase newTripUseCase(TripRepository tripRepository) {
  return _TripUseCase(tripRepository);
}

class _TripUseCase implements TripUseCase {
  const _TripUseCase(this._tripRepository);

  final TripRepository _tripRepository;

  @override
  Future<Result<Trip, TripError>> getTrip(int id, int userId) async {
    if (id <= 0 || userId <= 0) {
      return Result.failure(TripError.invalidTrip);
    }

    final result = await _tripRepository.getAllTrips(userId);
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

    return Result.failure(TripError.notFound);
  }

  @override
  Future<Result<int, TripError>> addTrip(Trip trip) async {
    final error = TripRules.validateTrip(trip);
    if (error != null) {
      return Result.failure(error);
    }

    return await _tripRepository.addTrip(trip);
  }

  @override
  Future<Result<void, TripError>> updateTrip(Trip trip) async {
    if (trip.id == null || trip.id! <= 0) {
      return Result.failure(TripError.invalidTrip);
    }

    final error = TripRules.validateTrip(trip);
    if (error != null) {
      return Result.failure(error);
    }

    return await _tripRepository.updateTrip(trip);
  }

  @override
  Future<Result<void, TripError>> deleteTrip(int id, int userId) async {
    if (id <= 0 || userId <= 0) {
      return Result.failure(TripError.invalidTrip);
    }

    return await _tripRepository.deleteTrip(id, userId);
  }

  @override
  Future<Result<List<Trip>, TripError>> getAllTrips(int userId) async {
    if (userId <= 0) {
      return Result.failure(TripError.invalidTrip);
    }

    return await _tripRepository.getAllTrips(userId);
  }
}
