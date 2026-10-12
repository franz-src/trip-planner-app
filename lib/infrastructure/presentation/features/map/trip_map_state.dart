import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/map/trip_map_arguments.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/details/trip_details_state.dart';
import 'package:trip_planner/shared/errors/error_stop.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';

/// State for destination maps, saved itineraries, and editable trip drafts.
class TripMapState with ChangeNotifier {
  /// Default constructor.
  TripMapState(
    AppState appState, {
    this.arguments,
    this.tripId,
    this.initialPosition,
  }) {
    if (arguments != null) {
      arguments!.editor.addListener(_onDraftChanged);
    } else if (tripId != null) {
      _details = TripDetailsState(appState, tripId!);
      _details!.addListener(_onTripChanged);
    }
  }

  /// Optional draft callbacks for editing stops on the map.
  final TripMapArguments? arguments;

  /// Identifier of a saved trip being viewed.
  final int? tripId;

  /// Optional destination selected through home search.
  final LatLng? initialPosition;

  /// Controller for map camera interactions.
  final MapController controller = MapController();

  TripDetailsState? _details;
  List<LatLng> _route = [];
  bool _ready = false;
  bool _disposed = false;
  bool _locating = false;
  LatLng? _currentPosition;
  int _routeRequest = 0;

  /// Stops in the editable draft or saved itinerary.
  List<Stop> get stops =>
      arguments?.editor.stops ?? _details?.trip?.stops ?? [];

  /// Road geometry for the current itinerary.
  List<LatLng> get route => arguments?.editor.route ?? _route;

  /// Whether saved itinerary data is being restored.
  bool get loading => _details?.loading ?? false;

  /// A saved itinerary loading failure.
  TripError? get error => _details?.error;

  /// Whether the device position is being located.
  bool get locating => _locating;

  /// The most recently located device position.
  LatLng? get currentPosition => _currentPosition;

  /// Initial center for the map camera.
  LatLng get center {
    if (initialPosition != null) {
      return initialPosition!;
    }

    if (stops.isNotEmpty) {
      return LatLng(stops.first.latitude, stops.first.longitude);
    }

    return const LatLng(-15.8, -47.9);
  }

  /// Fits the loaded itinerary once the map has attached its controller.
  void onMapReady() {
    _ready = true;
    fitItinerary();
  }

  /// Centers the camera on the destination or itinerary.
  void fitItinerary() {
    if (!_ready || _disposed) {
      return;
    }

    if (stops.length > 1) {
      controller.fitCamera(
        CameraFit.coordinates(
          coordinates: stops
              .map((stop) => LatLng(stop.latitude, stop.longitude))
              .toList(),
          padding: const EdgeInsets.all(50),
        ),
      );
    } else {
      controller.move(center, switch (initialPosition != null ||
          stops.isNotEmpty) {
        true => 12,
        false => 4,
      });
    }
  }

  void _onDraftChanged() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _onTripChanged() {
    if (_disposed) {
      return;
    }

    notifyListeners();
    if (!loading && _details?.trip != null) {
      _refreshRoute();
    }
  }

  Future<void> _refreshRoute() async {
    final request = ++_routeRequest;
    final points = stops
        .map((stop) => LatLng(stop.latitude, stop.longitude))
        .toList();
    _route = points;
    final result = await stopUseCase.getRoute(points);
    if (_disposed || request != _routeRequest) {
      return;
    }

    if (result case Success(:final value)) {
      _route = value;
    }

    notifyListeners();
  }

  /// Retries restoration of a saved itinerary.
  Future<void> reloadTrip() async {
    await _details?.loadTrip();
  }

  /// Requests permission and centers the camera on the device's location.
  Future<Result<LatLng, StopError>> locate() async {
    if (_locating) {
      return Result.failure(StopError.unexpected);
    }

    _locating = true;
    notifyListeners();
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return Result.failure(StopError.locationServicesDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return Result.failure(StopError.locationPermissionDenied);
      }

      final location = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 20),
        ),
      );
      final position = LatLng(location.latitude, location.longitude);
      if (!_disposed) {
        _currentPosition = position;
        if (_ready) {
          controller.move(position, 13);
        }
      }

      return Result.success(position);
    } catch (e) {
      return Result.failure(StopError.unexpected);
    } finally {
      _locating = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    arguments?.editor.removeListener(_onDraftChanged);
    _details?.removeListener(_onTripChanged);
    _details?.dispose();
    controller.dispose();
    super.dispose();
  }
}
