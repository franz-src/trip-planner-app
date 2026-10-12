import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_search_result.dart';
import 'package:trip_planner/shared/errors/error_search.dart';

/// Interface for destination search services.
abstract class SearchRepository {
  /// Returns destinations matching a query.
  Future<Result<List<SearchResult>, SearchError>> searchLocations(String query);
}

/// Interface for destination search actions.
abstract class SearchUseCase {
  /// Returns destinations matching a query.
  Future<Result<List<SearchResult>, SearchError>> searchLocations(String query);
}
