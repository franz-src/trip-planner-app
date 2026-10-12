import 'package:flutter/material.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/editor/trip_editor_state.dart';
import 'package:latlong2/latlong.dart';

/// Links the full-screen map to an existing trip draft.
class TripMapArguments {
  /// Default constructor.
  const TripMapArguments({
    required this.editor,
    required this.onMapTap,
    required this.onStopTap,
  });

  /// The live trip draft shared with the editor.
  final TripEditorState editor;

  /// Opens the draft's stop form for a map point.
  final Future<void> Function(BuildContext, LatLng) onMapTap;

  /// Opens the draft's stop form for an existing stop.
  final Future<void> Function(BuildContext, int) onStopTap;
}
