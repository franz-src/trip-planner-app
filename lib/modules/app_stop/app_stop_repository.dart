import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/modules/app_stop/app_stop_spec.dart';
import 'package:trip_planner/shared/errors/error_app_stop.dart';

AppStopRepository newAppStopRepository() => const _AppStopRepository();

class _AppStopRepository implements AppStopRepository {
  const _AppStopRepository();

  @override
  Future<Result<String?, AppStopError>> getAddressFromCoordinates(
    LatLng position,
  ) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'format': 'json',
      });
      final response = await http
          .get(
            uri,
            headers: {'User-Agent': 'TripPlanner/1.0 (trip_planner_app)'},
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return Result.failure(AppStopError.unexpected);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final address = data['address'] as Map<String, dynamic>?;
      final name =
          address?['city'] ??
          address?['town'] ??
          address?['village'] ??
          address?['suburb'] ??
          address?['country'];

      return Result.success(name as String?);
    } catch (e) {
      return Result.failure(AppStopError.unexpected);
    }
  }

  @override
  Future<Result<List<LatLng>, AppStopError>> getRoute(
    List<LatLng> points,
  ) async {
    if (points.length < 2) {
      return Result.success(points);
    }

    try {
      final coordinates = points
          .map((point) => '${point.longitude},${point.latitude}')
          .join(';');
      final uri = Uri.https(
        'router.project-osrm.org',
        '/route/v1/driving/$coordinates',
        {'overview': 'full', 'geometries': 'geojson'},
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return Result.failure(AppStopError.unexpected);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List;
      if (routes.isEmpty) {
        return Result.failure(AppStopError.unexpected);
      }

      final geometry = routes.first['geometry']['coordinates'] as List;
      final route = geometry
          .map(
            (point) => LatLng(
              (point[1] as num).toDouble(),
              (point[0] as num).toDouble(),
            ),
          )
          .toList();

      return Result.success(route);
    } catch (e) {
      return Result.failure(AppStopError.unexpected);
    }
  }
}
