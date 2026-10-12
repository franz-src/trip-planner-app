import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';

/// Interface for managing trip database actions.
abstract class TripRepository {
  /// Creates a trip and returns its identifier.
  Future<Result<int, TripError>> addTrip(Trip trip);

  /// Updates a trip and its related information.
  Future<Result<void, TripError>> updateTrip(Trip trip);

  /// Deletes a user's trip and its related information.
  Future<Result<void, TripError>> deleteTrip(int id, int userId);

  /// Returns the user's trips and their related information.
  Future<Result<List<Trip>, TripError>> getAllTrips(int userId);
}

/// Interface for managing trip actions.
abstract class TripUseCase {
  /// Returns one trip belonging to the current user.
  Future<Result<Trip, TripError>> getTrip(int id, int userId);

  /// Creates a trip and returns its identifier.
  Future<Result<int, TripError>> addTrip(Trip trip);

  /// Updates a trip and its related information.
  Future<Result<void, TripError>> updateTrip(Trip trip);

  /// Deletes a user's trip and its related information.
  Future<Result<void, TripError>> deleteTrip(int id, int userId);

  /// Returns the user's trips and their related information.
  Future<Result<List<Trip>, TripError>> getAllTrips(int userId);
}
