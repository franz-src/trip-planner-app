import 'package:flutter/material.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/details/trip_details_state.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';

/// State for viewing a stop within the current user's trip.
class StopDetailsState with ChangeNotifier {
  /// Default constructor.
  StopDetailsState(AppState appState, int tripId, this.stopId) {
    _details = TripDetailsState(appState, tripId);
    _details.addListener(notifyListeners);
  }

  late final TripDetailsState _details;

  /// Identifier of the requested stop.
  final int stopId;

  /// Whether the parent trip is being restored.
  bool get loading => _details.loading;

  /// Whether a user session is unavailable.
  bool get signedOut => _details.signedOut;

  /// The requested stop belonging to the restored trip.
  Stop? get stop {
    for (final stop in _details.trip?.stops ?? <Stop>[]) {
      if (stop.id == stopId) {
        return stop;
      }
    }

    return null;
  }

  /// The latest loading failure.
  TripError? get error {
    if (_details.error != null) {
      return _details.error;
    }

    if (!loading && !signedOut && stop == null) {
      return TripError.notFound;
    }

    return null;
  }

  /// Reloads the stop and its parent trip.
  Future<void> loadStop() => _details.loadTrip();

  @override
  void dispose() {
    _details.removeListener(notifyListeners);
    _details.dispose();
    super.dispose();
  }
}
