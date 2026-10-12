import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:latlong2/latlong.dart';
import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/entities/entity_stop_experience.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/shared/errors/error_app_person.dart';
import 'package:trip_planner/shared/errors/error_app_stop.dart';
import 'package:trip_planner/shared/errors/error_app_trip.dart';
import 'package:trip_planner/shared/validations/validation_app_trip.dart';

/// State for creating and editing trips.
class TripEditorState with ChangeNotifier {
  /// Default constructor.
  TripEditorState(this._appState, {this.tripId}) {
    _loadTrip();
  }

  final AppState _appState;

  /// Identifier of the trip being edited, or null when creating a trip.
  final int? tripId;

  /// Controller for the trip title.
  final TextEditingController controllerTitle = TextEditingController();

  /// Controller for a group member's name.
  final TextEditingController controllerName = TextEditingController();

  /// Controller for a group member's age.
  final TextEditingController controllerAge = TextEditingController();

  /// Controller for the stop's destination name.
  final TextEditingController controllerLocation = TextEditingController();

  /// Controller for the stop's arrival date.
  final TextEditingController controllerStartDate = TextEditingController();

  /// Controller for the stop's departure date.
  final TextEditingController controllerEndDate = TextEditingController();

  /// Controller for the stop's latitude.
  final TextEditingController controllerLatitude = TextEditingController();

  /// Controller for the stop's longitude.
  final TextEditingController controllerLongitude = TextEditingController();

  /// Repaint boundary used to capture the itinerary map.
  final GlobalKey mapKey = GlobalKey();

  Trip? _original;
  int? _userId;
  String _transport = 'Car';
  List<Person> _group = [];
  List<Stop> _stops = [];
  List<StopExperience> _experiences = [];
  List<LatLng> _route = [];
  int? _personIndex;
  int? _stopIndex;
  int _routeRequest = 0;
  int _addressRequest = 0;
  bool _loading = true;
  bool _saving = false;
  bool _disposed = false;
  AppTripError? _error;
  AppTripError? _loadError;

  /// Selected means of transport.
  String get transport => _transport;

  /// Members of the trip's travel group.
  List<Person> get group => List.unmodifiable(_group);

  /// Stops in itinerary order.
  List<Stop> get stops => List.unmodifiable(_stops);

  /// Experiences selected in the stop form.
  List<StopExperience> get experiences => List.unmodifiable(_experiences);

  /// Geographic route for the itinerary map.
  List<LatLng> get route => List.unmodifiable(_route);

  /// Whether session and trip data are being restored.
  bool get loading => _loading;

  /// Whether a trip save is in progress.
  bool get saving => _saving;

  /// Whether the group form is editing an existing member.
  bool get editingPerson => _personIndex != null;

  /// Whether the trip has been concluded and can only be viewed.
  bool get readOnly => _original?.concluded ?? false;

  /// Whether the session is unavailable.
  bool get signedOut => _appState.appUser == null;

  /// The latest loading or saving failure.
  AppTripError? get error => _error;

  /// A failure encountered while restoring the session or trip.
  AppTripError? get loadError => _loadError;

  Future<void> _loadTrip() async {
    final session = await _appState.refreshUser();
    if (_disposed) {
      return;
    }

    switch (session) {
      case Failure():
        _loadError = AppTripError.unexpected;
      case Success(:final value):
        _userId = value?.id;
        if (value != null && tripId != null) {
          final result = await appTripUseCase.getAllTrips(value.id);
          if (_disposed) {
            return;
          }

          switch (result) {
            case Failure(:final error):
              _loadError = error;
            case Success(:final value):
              for (final trip in value) {
                if (trip.id == tripId) {
                  _original = trip;
                  controllerTitle.text = trip.title;
                  _transport = trip.transport;
                  _group = List.of(trip.group);
                  _stops = List.of(trip.stops);
                }
              }

              if (_original == null) {
                _loadError = AppTripError.notFound;
              }
          }
        }
    }

    _loading = false;
    notifyListeners();
    _refreshRoute();
  }

  /// Changes the selected transport.
  void setTransport(String transport) {
    _transport = transport;
    notifyListeners();
  }

  /// Loads a group member into the form while preserving its identifier.
  void editPerson(int index) {
    _personIndex = index;
    controllerName.text = _group[index].name;
    controllerAge.text = _group[index].age.toString();
    notifyListeners();
  }

  /// Adds or updates a validated group member.
  Result<Person, AppPersonError> savePerson() {
    final result = appPersonUseCase.createPerson(
      controllerName.text,
      controllerAge.text,
    );
    if (result case Success(:final value)) {
      final index = _personIndex;
      if (index == null) {
        _group.add(value);
      } else {
        _group[index] = _group[index].copyWith(
          name: value.name,
          age: value.age,
        );
      }

      _personIndex = null;
      controllerName.clear();
      controllerAge.clear();
      notifyListeners();
    }

    return result;
  }

  /// Removes a group member from the draft.
  void removePerson(int index) {
    _group.removeAt(index);
    _personIndex = null;
    controllerName.clear();
    controllerAge.clear();
    notifyListeners();
  }

  /// Initializes the stop form from a map point or an existing stop.
  void beginStop({LatLng? position, int? index}) {
    _addressRequest++;
    _stopIndex = index;
    _experiences = [];
    controllerLocation.clear();
    controllerStartDate.clear();
    controllerEndDate.clear();
    if (index != null) {
      final stop = _stops[index];
      controllerLocation.text = stop.location;
      controllerStartDate.text = stop.startDate;
      controllerEndDate.text = stop.endDate;
      controllerLatitude.text = stop.latitude.toString();
      controllerLongitude.text = stop.longitude.toString();
      _experiences = List.of(stop.stopExperiences);
    } else {
      controllerLatitude.text = (position?.latitude ?? 0).toString();
      controllerLongitude.text = (position?.longitude ?? 0).toString();
      if (_stops.isNotEmpty) {
        controllerStartDate.text = _stops.last.endDate;
        controllerEndDate.text = _stops.last.endDate;
      }

      if (position != null) {
        _findAddress(position, _addressRequest);
      }
    }

    notifyListeners();
  }

  Future<void> _findAddress(LatLng position, int request) async {
    final result = await appStopUseCase.getAddressFromCoordinates(position);
    if (_disposed ||
        request != _addressRequest ||
        controllerLocation.text.isNotEmpty) {
      return;
    }

    if (result case Success(:final value)) {
      controllerLocation.text = value ?? '';
    }
  }

  /// Invalidates any pending destination lookup when a stop form closes.
  void closeStop() {
    _addressRequest++;
  }

  /// Adds or removes an experience selection.
  void toggleExperience(String experience, bool selected) {
    if (selected) {
      if (!_experiences.any((value) => value.experience == experience)) {
        var selectedExperience = StopExperience(experience: experience);
        final index = _stopIndex;
        if (index != null) {
          for (final original in _stops[index].stopExperiences) {
            if (original.experience == experience) {
              selectedExperience = original;
              break;
            }
          }
        }

        _experiences.add(selectedExperience);
      }
    } else {
      _experiences.removeWhere((value) => value.experience == experience);
    }

    notifyListeners();
  }

  /// Adds or updates a validated stop while preserving related identifiers.
  Result<Stop, AppStopError> saveStop() {
    final latitude = double.tryParse(controllerLatitude.text);
    final longitude = double.tryParse(controllerLongitude.text);
    if (latitude == null || longitude == null) {
      return Result.failure(AppStopError.invalidCoordinates);
    }

    final index = _stopIndex;
    Stop? original;
    if (index != null) {
      original = _stops[index];
    }

    final stop = Stop(
      id: original?.id,
      tripId: original?.tripId,
      img: original?.img,
      location: controllerLocation.text.trim(),
      startDate: controllerStartDate.text,
      endDate: controllerEndDate.text,
      latitude: latitude,
      longitude: longitude,
      stopExperiences: List.of(_experiences),
    );
    final result = appStopUseCase.validateStop(stop);
    if (result is Success<Stop, AppStopError>) {
      if (index == null) {
        _stops.add(stop);
      } else {
        _stops[index] = stop;
      }

      notifyListeners();
      _refreshRoute();
    }

    return result;
  }

  /// Removes a stop from the draft itinerary.
  void removeStop(int index) {
    _stops.removeAt(index);
    notifyListeners();
    _refreshRoute();
  }

  Future<void> _refreshRoute() async {
    final request = ++_routeRequest;
    final points = _stops
        .map((stop) => LatLng(stop.latitude, stop.longitude))
        .toList();
    _route = points;
    final result = await appStopUseCase.getRoute(points);
    if (_disposed || request != _routeRequest) {
      return;
    }

    if (result case Success(:final value)) {
      _route = value;
    }

    notifyListeners();
  }

  /// Saves the trip through the application trip module.
  Future<Result<int, AppTripError>> saveTrip() async {
    final userId = _userId;
    if (_loading ||
        _saving ||
        userId == null ||
        _appState.appUser?.id != userId ||
        (tripId != null && _original == null)) {
      return Result.failure(AppTripError.invalidTrip);
    }

    if (readOnly) {
      return Result.failure(AppTripError.concludedTrip);
    }

    final start = switch (_stops.isEmpty) {
      true => '',
      false => _stops.first.startDate,
    };
    final end = switch (_stops.isEmpty) {
      true => '',
      false => _stops.last.endDate,
    };
    var trip = Trip(
      id: tripId,
      userId: userId,
      title: controllerTitle.text.trim(),
      transport: _transport,
      startDate: start,
      endDate: end,
      group: List.of(_group),
      stops: List.of(_stops),
      mapImage: _original?.mapImage,
    );
    final error = AppTripRules.validateTrip(trip);
    if (error != null) {
      _error = error;
      notifyListeners();

      return Result.failure(error);
    }

    _saving = true;
    _error = null;
    notifyListeners();
    try {
      await WidgetsBinding.instance.endOfFrame;
      if (_disposed) {
        return Result.failure(AppTripError.unexpected);
      }

      final boundary = mapKey.currentContext?.findRenderObject();
      if (boundary is RenderRepaintBoundary && !boundary.debugNeedsPaint) {
        final image = await boundary.toImage(pixelRatio: 2);
        try {
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          if (bytes != null) {
            trip = trip.copyWith(mapImage: bytes.buffer.asUint8List());
          }
        } finally {
          image.dispose();
        }
      }

      if (_disposed || _appState.appUser?.id != userId) {
        return Result.failure(AppTripError.invalidTrip);
      }

      if (tripId == null) {
        return await appTripUseCase.addTrip(trip);
      }

      final result = await appTripUseCase.updateTrip(trip);
      return switch (result) {
        Success() => Result.success(tripId!),
        Failure(:final error) => Result.failure(error),
      };
    } catch (e) {
      return Result.failure(AppTripError.unexpected);
    } finally {
      _saving = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    for (final controller in [
      controllerTitle,
      controllerName,
      controllerAge,
      controllerLocation,
      controllerStartDate,
      controllerEndDate,
      controllerLatitude,
      controllerLongitude,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }
}
