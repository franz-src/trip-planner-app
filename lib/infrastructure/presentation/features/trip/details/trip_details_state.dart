import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/shared/errors/error_app_trip.dart';

/// State for viewing a trip belonging to the current user.
class TripDetailsState with ChangeNotifier {
  /// Default constructor.
  TripDetailsState(this._appState, this.tripId) {
    loadTrip();
  }

  final AppState _appState;

  /// Identifier of the requested trip.
  final int tripId;

  Trip? _trip;
  AppTripError? _error;
  bool _loading = true;
  bool _deleting = false;
  bool _disposed = false;
  int _request = 0;

  /// The restored trip.
  Trip? get trip => _trip;

  /// Whether the trip is being restored.
  bool get loading => _loading;

  /// Whether account ownership is unavailable.
  bool get signedOut => _appState.appUser == null;

  /// Whether the trip is being deleted.
  bool get deleting => _deleting;

  /// The latest loading failure.
  AppTripError? get error => _error;

  /// Restores the session and reloads the requested trip.
  Future<void> loadTrip() async {
    final request = ++_request;
    _loading = true;
    _error = null;
    if (!_disposed) {
      notifyListeners();
    }

    final session = await _appState.refreshUser();
    if (_disposed || request != _request) {
      return;
    }

    switch (session) {
      case Failure():
        _error = AppTripError.unexpected;
        _trip = null;
      case Success(:final value):
        _trip = null;
        if (value != null) {
          final result = await appTripUseCase.getTrip(tripId, value.id);
          if (_disposed || request != _request) {
            return;
          }

          switch (result) {
            case Success(:final value):
              _trip = value;
            case Failure(:final error):
              _error = error;
          }
        }
    }

    _loading = false;
    notifyListeners();
  }

  /// Deletes the currently displayed trip.
  Future<Result<void, AppTripError>> deleteTrip() async {
    final trip = _trip;
    final userId = _appState.appUser?.id;
    if (trip == null || userId == null || trip.userId != userId || _deleting) {
      return Result.failure(AppTripError.invalidTrip);
    }

    _deleting = true;
    notifyListeners();
    final result = await appTripUseCase.deleteTrip(tripId, userId);
    if (!_disposed) {
      _deleting = false;
      notifyListeners();
    }

    return result;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
