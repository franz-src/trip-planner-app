import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_search_result.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/shared/errors/error_search.dart';

/// State for home destination search.
class HomeState with ChangeNotifier {
  /// Controller for the destination query.
  final TextEditingController controllerSearch = TextEditingController();

  Timer? _debounce;
  int _request = 0;
  bool _disposed = false;
  bool _loading = false;
  String _query = '';
  List<SearchResult> _results = [];
  SearchError? _error;

  /// Whether destination search is pending.
  bool get loading => _loading;

  /// The current destination query.
  String get query => _query;

  /// Results matching the current query.
  List<SearchResult> get results => List.unmodifiable(_results);

  /// The latest search failure.
  SearchError? get error => _error;

  /// Debounces search input and ignores obsolete responses.
  void search(String query) {
    _debounce?.cancel();
    final request = ++_request;
    _query = query.trim();
    _results = [];
    _error = null;
    _loading = _query.isNotEmpty;
    notifyListeners();
    if (_query.isNotEmpty) {
      _debounce = Timer(
        const Duration(seconds: 1),
        () => _search(request, _query),
      );
    }
  }

  Future<void> _search(int request, String query) async {
    final result = await searchUseCase.searchLocations(query);
    if (_disposed || request != _request) {
      return;
    }

    switch (result) {
      case Success(:final value):
        _results = value;
      case Failure(:final error):
        _error = error;
    }

    _loading = false;
    notifyListeners();
  }

  /// Clears the query and cancels pending responses.
  void clearSearch() {
    controllerSearch.clear();
    search('');
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    controllerSearch.dispose();
    super.dispose();
  }
}
