import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/shared/errors/error_stop.dart';

/// Interface for destination and route services.
abstract class StopRepository {
  /// Finds the place name for geographic coordinates.
  Future<Result<String?, StopError>> getAddressFromCoordinates(LatLng position);

  /// Returns a driving route for the supplied stops.
  Future<Result<List<LatLng>, StopError>> getRoute(List<LatLng> points);
}

/// Interface for managing itinerary stops.
abstract class StopUseCase {
  /// Validates a stop before adding it to an itinerary.
  Result<Stop, StopError> validateStop(Stop stop);

  /// Finds the place name for geographic coordinates.
  Future<Result<String?, StopError>> getAddressFromCoordinates(LatLng position);

  /// Returns a driving route for the supplied stops.
  Future<Result<List<LatLng>, StopError>> getRoute(List<LatLng> points);
}
