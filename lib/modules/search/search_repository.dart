import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_search_result.dart';
import 'package:trip_planner/modules/search/search_spec.dart';
import 'package:trip_planner/shared/errors/error_search.dart';

SearchRepository newSearchRepository() => const _SearchRepository();

class _SearchRepository implements SearchRepository {
  const _SearchRepository();

  @override
  Future<Result<List<SearchResult>, SearchError>> searchLocations(
    String query,
  ) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'limit': '5',
        'addressdetails': '1',
      });
      final response = await http
          .get(uri, headers: {'User-Agent': 'TripPlannerApp/1.0'})
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return Result.failure(SearchError.unexpected);
      }

      final values = jsonDecode(response.body) as List;
      final results = values
          .map((value) => SearchResult.fromJSON(value as Map<String, dynamic>))
          .toList();

      return Result.success(results);
    } catch (e) {
      return Result.failure(SearchError.unexpected);
    }
  }
}
