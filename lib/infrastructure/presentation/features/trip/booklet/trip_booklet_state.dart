import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/pdf/trip_booklet_exporter.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/details/trip_details_state.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';
import 'package:trip_planner/shared/errors/error_trip_booklet.dart';

/// State for collecting memories and generating a trip booklet.
class TripBookletState with ChangeNotifier {
  /// Default constructor.
  TripBookletState(AppState appState, int tripId) {
    _appState = appState;
    _details = TripDetailsState(appState, tripId);
    _details.addListener(_onDetailsChanged);
  }

  late final AppState _appState;
  late final TripDetailsState _details;
  final ImagePicker _picker = ImagePicker();
  final Map<int, Uint8List> _personPhotos = {};
  final Map<int, List<Uint8List>> _stopPhotos = {};
  final Map<int, TextEditingController> _descriptions = {};
  bool _prepared = false;
  bool _generating = false;
  bool _picking = false;
  bool _disposed = false;
  Uint8List? _document;

  /// The owned trip being exported.
  Trip? get trip => _details.trip;

  /// Whether trip data is being restored.
  bool get loading => _details.loading;

  /// The latest trip loading failure.
  TripError? get error => _details.error;

  /// Whether PDF generation is in progress.
  bool get generating => _generating;

  /// Whether photo selection is in progress.
  bool get picking => _picking;

  /// The generated PDF bytes, or null before generation.
  Uint8List? get document => _document;

  /// Returns the selected member photo.
  Uint8List? personPhoto(int index) => _personPhotos[index];

  /// Returns the selected stop photos.
  List<Uint8List> stopPhotos(int index) =>
      List.unmodifiable(_stopPhotos[index] ?? []);

  /// Returns the controller for a stop's written memories.
  TextEditingController descriptionController(int index) =>
      _descriptions[index]!;

  void _onDetailsChanged() {
    final currentTrip = trip;
    if (!_prepared && currentTrip != null) {
      for (var index = 0; index < currentTrip.stops.length; index++) {
        _stopPhotos[index] = [];
        _descriptions[index] = TextEditingController();
      }

      _prepared = true;
    }

    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Retries loading the trip.
  Future<void> loadTrip() => _details.loadTrip();

  /// Selects or replaces a group member's gallery photo.
  Future<Result<void, TripBookletError>> pickPersonPhoto(int index) =>
      _pickPhoto(index, person: true);

  /// Adds a gallery photo to a stop's memories.
  Future<Result<void, TripBookletError>> pickStopPhoto(int index) =>
      _pickPhoto(index, person: false);

  Future<Result<void, TripBookletError>> _pickPhoto(
    int index, {
    required bool person,
  }) async {
    if (_picking || _generating || !_prepared) {
      return Result.failure(TripBookletError.unexpected);
    }

    _picking = true;
    notifyListeners();
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (image == null || _disposed) {
        return Result.success(null);
      }

      final bytes = await image.readAsBytes();
      if (_disposed) {
        return Result.success(null);
      }

      if (person) {
        _personPhotos[index] = bytes;
      } else {
        _stopPhotos[index]!.add(bytes);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(TripBookletError.unexpected);
    } finally {
      _picking = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  /// Removes a photo from a stop's memories.
  void removeStopPhoto(int index, int photoIndex) {
    _stopPhotos[index]!.removeAt(photoIndex);
    notifyListeners();
  }

  /// Returns from PDF preview to the collected memories.
  void editMemories() {
    _document = null;
    notifyListeners();
  }

  /// Generates a PDF after checking the required photos and descriptions.
  Future<Result<void, TripBookletError>> generate(AppLocalizations intl) async {
    final currentTrip = trip;
    if (_generating ||
        _picking ||
        currentTrip == null ||
        currentTrip.userId != _appState.user?.id) {
      return Result.failure(TripBookletError.unexpected);
    }

    if (!currentTrip.concluded) {
      return Result.failure(TripBookletError.notConcluded);
    }

    for (var index = 0; index < currentTrip.group.length; index++) {
      if (!_personPhotos.containsKey(index)) {
        return Result.failure(TripBookletError.missingPersonPhotos);
      }
    }

    for (var index = 0; index < currentTrip.stops.length; index++) {
      if (_stopPhotos[index]!.isEmpty ||
          _descriptions[index]!.text.trim().isEmpty) {
        return Result.failure(TripBookletError.missingStopData);
      }
    }

    _generating = true;
    notifyListeners();
    try {
      final descriptions = _descriptions.map(
        (key, controller) => MapEntry(key, controller.text.trim()),
      );
      final bytes = await TripBookletExporter.generate(
        currentTrip,
        _personPhotos,
        _stopPhotos,
        descriptions,
        intl,
      );
      if (!_disposed) {
        _document = bytes;
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(TripBookletError.unexpected);
    } finally {
      _generating = false;
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _details.removeListener(_onDetailsChanged);
    _details.dispose();
    for (final controller in _descriptions.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
