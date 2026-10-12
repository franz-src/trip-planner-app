import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_search_result.dart';
import 'package:trip_planner/modules/search/search_spec.dart';
import 'package:trip_planner/shared/errors/error_search.dart';

SearchUseCase newSearchUseCase(SearchRepository repository) =>
    _SearchUseCase(repository);

class _SearchUseCase implements SearchUseCase {
  const _SearchUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Result<List<SearchResult>, SearchError>> searchLocations(
    String query,
  ) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Result.success([]);
    }

    return await _repository.searchLocations(trimmed);
  }
}
