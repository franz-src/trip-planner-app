import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/map/trip_map_arguments.dart';
import 'package:trip_planner/infrastructure/presentation/features/map/trip_map_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';

class TripMapScreen extends StatelessWidget {
  const TripMapScreen({
    super.key,
    this.arguments,
    this.tripId,
    this.initialPosition,
    this.locationName,
  });

  final TripMapArguments? arguments;
  final int? tripId;
  final LatLng? initialPosition;
  final String? locationName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey('$tripId:$initialPosition:${arguments?.editor}'),
      create: (_) => TripMapState(
        context.read<AppState>(),
        arguments: arguments,
        tripId: tripId,
        initialPosition: initialPosition,
      ),
      child: _TripMapScreen(locationName: locationName),
    );
  }
}

class _TripMapScreen extends StatelessWidget {
  const _TripMapScreen({this.locationName});

  final String? locationName;

  Future<void> _locate(BuildContext context, TripMapState state) async {
    final result = await state.locate();
    if (!context.mounted) {
      return;
    }

    if (result case Failure(:final error)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.translate(AppLocalizations.of(context)))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locationName ?? intl.map),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
      ),
      body: Consumer<TripMapState>(
        builder: (context, state, child) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final error = state.error;
          if (error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error.translate(intl)),
                  TextButton(
                    onPressed: state.reloadTrip,
                    child: Text(intl.tryAgain),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: state.controller,
                options: MapOptions(
                  initialCenter: state.center,
                  initialZoom: 4,
                  onMapReady: state.onMapReady,
                  onTap: (tap, position) {
                    final arguments = state.arguments;
                    if (arguments != null &&
                        !arguments.editor.saving &&
                        !arguments.editor.readOnly) {
                      arguments.onMapTap(context, position);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.trip_planner',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.route,
                        strokeWidth: 4,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      if (state.initialPosition != null)
                        Marker(
                          point: state.initialPosition!,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      if (state.currentPosition case final position?)
                        Marker(
                          point: position,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                          ),
                        ),
                      for (var index = 0; index < state.stops.length; index++)
                        Marker(
                          point: LatLng(
                            state.stops[index].latitude,
                            state.stops[index].longitude,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              final arguments = state.arguments;
                              if (arguments != null) {
                                if (!arguments.editor.saving &&
                                    !arguments.editor.readOnly) {
                                  arguments.onStopTap(context, index);
                                }
                              } else if (state.tripId != null &&
                                  state.stops[index].id != null) {
                                context.go(
                                  AppRoutes.stopDetailsPath(
                                    state.tripId!,
                                    state.stops[index].id!,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution('OpenStreetMap contributors'),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'fit-map',
                      tooltip: intl.tripRoute,
                      onPressed: state.fitItinerary,
                      child: const Icon(Icons.center_focus_strong),
                    ),
                    FloatingActionButton.small(
                      heroTag: 'locate-map',
                      tooltip: intl.myLocation,
                      onPressed: switch (state.locating) {
                        true => null,
                        false => () => _locate(context, state),
                      },
                      child: switch (state.locating) {
                        true => const CircularProgressIndicator(),
                        false => const Icon(Icons.my_location),
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
