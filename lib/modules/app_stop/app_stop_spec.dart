import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/shared/errors/error_app_stop.dart';

/// Interface for destination and route services.
abstract class AppStopRepository {
  /// Finds the place name for geographic coordinates.
  Future<Result<String?, AppStopError>> getAddressFromCoordinates(
    LatLng position,
  );

  /// Returns a driving route for the supplied stops.
  Future<Result<List<LatLng>, AppStopError>> getRoute(List<LatLng> points);
}

/// Interface for managing itinerary stops.
abstract class AppStopUseCase {
  /// Validates a stop before adding it to an itinerary.
  Result<Stop, AppStopError> validateStop(Stop stop);

  /// Finds the place name for geographic coordinates.
  Future<Result<String?, AppStopError>> getAddressFromCoordinates(
    LatLng position,
  );

  /// Returns a driving route for the supplied stops.
  Future<Result<List<LatLng>, AppStopError>> getRoute(List<LatLng> points);
}
