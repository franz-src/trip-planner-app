import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';
import 'package:trip_planner/shared/validations/validation_stop.dart';

/// State for the current user's trip list.
class TripListState with ChangeNotifier {
  /// Default constructor.
  TripListState(this._appState) {
    _tripRevision = _appState.tripRevision;
    _appState.addListener(_onTripsChanged);
    loadTrips();
  }

  final AppState _appState;
  List<Trip> _trips = [];
  bool _loading = true;
  bool _disposed = false;
  TripError? _error;
  int _request = 0;
  int? _userId;
  int _tripRevision = 0;
  final Set<int> _busyTrips = {};

  void _onTripsChanged() {
    if (!_disposed && _tripRevision != _appState.tripRevision) {
      _tripRevision = _appState.tripRevision;
      loadTrips();
    }
  }

  /// Trips belonging to the current user.
  List<Trip> get trips => List.unmodifiable(_trips);

  /// Whether trips are being loaded.
  bool get loading => _loading;

  /// The latest trip-list failure.
  TripError? get error => _error;

  /// Whether a session is available for the list.
  bool get signedOut => _appState.user == null;

  /// Whether an action is in progress for a trip.
  bool isBusy(Trip trip) => _busyTrips.contains(trip.id);

  /// Whether a trip ended before today.
  bool isExpired(Trip trip) {
    final end = StopRules.parseDate(trip.endDate);
    if (end == null) {
      return false;
    }

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).isAfter(end);
  }

  /// Restores the session and reloads its trips.
  Future<void> loadTrips() async {
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
        _trips = [];
        _error = TripError.unexpected;
      case Success(:final value):
        _userId = value?.id;
        if (value == null) {
          _trips = [];
        } else {
          final result = await tripUseCase.getAllTrips(value.id);
          if (_disposed || request != _request) {
            return;
          }

          switch (result) {
            case Success(:final value):
              _trips = value;
            case Failure(:final error):
              _error = error;
          }
        }
    }

    _loading = false;
    notifyListeners();
  }

  /// Marks an expired trip as concluded.
  Future<Result<void, TripError>> concludeTrip(Trip trip) async {
    final id = trip.id;
    if (id == null ||
        !isExpired(trip) ||
        trip.concluded ||
        isBusy(trip) ||
        _appState.user?.id != _userId) {
      return Result.failure(TripError.invalidTrip);
    }

    _busyTrips.add(id);
    notifyListeners();
    final result = await tripUseCase.updateTrip(trip.copyWith(concluded: true));
    if (!_disposed) {
      _busyTrips.remove(id);
      if (result is Success<void, TripError>) {
        _appState.markTripsChanged();
        _trips = _trips.map((value) {
          if (value.id == id) {
            return value.copyWith(concluded: true);
          }

          return value;
        }).toList();
      }

      notifyListeners();
    }

    return result;
  }

  /// Deletes a trip belonging to the current user.
  Future<Result<void, TripError>> deleteTrip(Trip trip) async {
    final id = trip.id;
    final userId = _userId;
    if (id == null ||
        userId == null ||
        isBusy(trip) ||
        _appState.user?.id != userId) {
      return Result.failure(TripError.invalidTrip);
    }

    _busyTrips.add(id);
    notifyListeners();
    final result = await tripUseCase.deleteTrip(id, userId);
    if (!_disposed) {
      _busyTrips.remove(id);
      if (result is Success<void, TripError>) {
        _appState.markTripsChanged();
        _trips.removeWhere((value) => value.id == id);
      }

      notifyListeners();
    }

    return result;
  }

  @override
  void dispose() {
    _disposed = true;
    _appState.removeListener(_onTripsChanged);
    super.dispose();
  }
}
