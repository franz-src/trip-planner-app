import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/infrastructure/presentation/app/components/text_field_component.dart';
import 'package:trip_planner/infrastructure/presentation/app/components/text_field_date_component.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/editor/trip_editor_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';
import 'package:trip_planner/shared/validations/validation_stop.dart';
import 'package:trip_planner/infrastructure/presentation/features/map/trip_map_arguments.dart';

class TripEditorScreen extends StatelessWidget {
  const TripEditorScreen({super.key, this.tripId});

  final int? tripId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey(tripId),
      create: (_) => TripEditorState(context.read<AppState>(), tripId: tripId),
      child: const _TripEditorScreen(),
    );
  }
}

class _TripEditorScreen extends StatelessWidget {
  const _TripEditorScreen();

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final initial = StopRules.parseDate(controller.text) ?? DateTime.now();
    var first = DateTime(1900);
    var last = DateTime(2100);
    if (initial.isBefore(first)) {
      first = initial;
    }

    if (initial.isAfter(last)) {
      last = initial;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (date != null && context.mounted) {
      controller.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _editStop(
    BuildContext context,
    TripEditorState state, {
    LatLng? position,
    int? index,
  }) async {
    if (state.readOnly || state.saving) {
      return;
    }

    state.beginStop(position: position, index: index);
    final intl = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: state,
        child: Consumer<TripEditorState>(
          builder: (context, state, child) {
            final choices = <String>{
              intl.immersionDifferentCulture,
              intl.exploreAlternativeCuisines,
              intl.visitHistoricalSites,
              intl.visitLocalEstablishments,
              intl.contactWithNature,
              ...state.experiences.map((value) => value.experience),
            };

            return AlertDialog(
              title: Text(switch (index) {
                null => intl.addStop,
                _ => intl.edit,
              }),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldComponent(
                        controller: state.controllerLocation,
                        label: intl.destination,
                      ),
                      TextFieldComponent(
                        controller: state.controllerLatitude,
                        label: intl.latitude,
                      ),
                      TextFieldComponent(
                        controller: state.controllerLongitude,
                        label: intl.longitude,
                      ),
                      TextFieldDateComponent(
                        controller: state.controllerStartDate,
                        hint: intl.startDate,
                        function: () =>
                            _pickDate(context, state.controllerStartDate),
                      ),
                      TextFieldDateComponent(
                        controller: state.controllerEndDate,
                        hint: intl.endDate,
                        function: () =>
                            _pickDate(context, state.controllerEndDate),
                      ),
                      for (final choice in choices)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(choice),
                          value: state.experiences.any(
                            (value) => value.experience == choice,
                          ),
                          onChanged: (value) =>
                              state.toggleExperience(choice, value ?? false),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(intl.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final result = state.saveStop();
                    switch (result) {
                      case Success():
                        Navigator.of(dialogContext).pop();
                      case Failure(:final error):
                        _showError(context, error.translate(intl));
                    }
                  },
                  child: Text(intl.saveChanges),
                ),
              ],
            );
          },
        ),
      ),
    );
    state.closeStop();
  }

  Future<void> _save(BuildContext context, TripEditorState state) async {
    final result = await state.saveTrip();
    if (!context.mounted) {
      return;
    }

    switch (result) {
      case Success(:final value):
        if (context.canPop()) {
          context.pop(value);
        } else {
          context.go(AppRoutes.trips);
        }
      case Failure(:final error):
        _showError(context, error.translate(AppLocalizations.of(context)));
    }
  }

  Widget _section(
    BuildContext context,
    String title,
    IconData icon,
    Widget child,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    color: theme.colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(intl.tripData)),
      body: Consumer<TripEditorState>(
        builder: (context, state, child) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final loadError = state.loadError;
          if (loadError != null) {
            return Center(child: Text(loadError.translate(intl)));
          }

          if (state.signedOut) {
            return Center(
              child: FilledButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(intl.signIn),
              ),
            );
          }

          final transportOptions = <String, String>{
            'Car': intl.car,
            'Motorcycle': intl.motorcycle,
            'Bus': intl.bus,
            'Airplane': intl.airplane,
            'Ship': intl.ship,
          };
          transportOptions.putIfAbsent(state.transport, () => state.transport);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.readOnly)
                  Text(
                    intl.concludedTrips,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                AbsorbPointer(
                  absorbing: state.saving || state.readOnly,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _section(
                        context,
                        intl.tripData,
                        Icons.flight_takeoff,
                        Column(
                          children: [
                            TextFieldComponent(
                              controller: state.controllerTitle,
                              label: intl.tripTitle,
                            ),
                            DropdownButtonFormField<String>(
                              key: ValueKey(state.transport),
                              initialValue: state.transport,
                              decoration: InputDecoration(
                                labelText: intl.transport,
                              ),
                              items: transportOptions.entries
                                  .map(
                                    (entry) => DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  state.setTransport(value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      _section(
                        context,
                        intl.groupData,
                        Icons.group,
                        Column(
                          children: [
                            TextFieldComponent(
                              controller: state.controllerName,
                              label: intl.name,
                            ),
                            TextFieldComponent(
                              controller: state.controllerAge,
                              label: intl.age,
                            ),
                            FilledButton(
                              onPressed: () {
                                final result = state.savePerson();
                                if (result case Failure(:final error)) {
                                  _showError(context, error.translate(intl));
                                }
                              },
                              child: Text(switch (state.editingPerson) {
                                true => intl.saveChanges,
                                false => intl.addPerson,
                              }),
                            ),
                            for (
                              var index = 0;
                              index < state.group.length;
                              index++
                            )
                              ListTile(
                                title: Text(state.group[index].name),
                                subtitle: Text('${state.group[index].age}'),
                                onTap: () => state.editPerson(index),
                                trailing: IconButton(
                                  tooltip: intl.delete,
                                  icon: const Icon(Icons.close),
                                  onPressed: () => state.removePerson(index),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _section(
                        context,
                        intl.map,
                        Icons.map,
                        Column(
                          children: [
                            RepaintBoundary(
                              key: state.mapKey,
                              child: SizedBox(
                                height: 300,
                                child: FlutterMap(
                                  key: ValueKey(state.tripId),
                                  options: MapOptions(
                                    initialCenter:
                                        switch (state.stops.isEmpty) {
                                          true => const LatLng(-15.8, -47.9),
                                          false => LatLng(
                                            state.stops.first.latitude,
                                            state.stops.first.longitude,
                                          ),
                                        },
                                    initialZoom: 4,
                                    onTap: (tap, position) => _editStop(
                                      context,
                                      state,
                                      position: position,
                                    ),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.example.trip_planner',
                                    ),
                                    PolylineLayer(
                                      polylines: [
                                        Polyline(
                                          points: state.route,
                                          strokeWidth: 4,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        for (
                                          var index = 0;
                                          index < state.stops.length;
                                          index++
                                        )
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
                                              onPressed: () => _editStop(
                                                context,
                                                state,
                                                index: index,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const RichAttributionWidget(
                                      attributions: [
                                        TextSourceAttribution(
                                          'OpenStreetMap contributors',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push(
                                AppRoutes.map,
                                extra: TripMapArguments(
                                  editor: state,
                                  onMapTap: (mapContext, position) => _editStop(
                                    mapContext,
                                    state,
                                    position: position,
                                  ),
                                  onStopTap: (mapContext, index) => _editStop(
                                    mapContext,
                                    state,
                                    index: index,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.fullscreen),
                              label: Text(intl.fullscreenMap),
                            ),
                            FilledButton.icon(
                              onPressed: () => _editStop(context, state),
                              icon: const Icon(Icons.add_location_alt),
                              label: Text(intl.addStop),
                            ),
                            for (
                              var index = 0;
                              index < state.stops.length;
                              index++
                            )
                              ListTile(
                                title: Text(state.stops[index].location),
                                subtitle: Text(
                                  '${state.stops[index].startDate} - ${state.stops[index].endDate}',
                                ),
                                onTap: () =>
                                    _editStop(context, state, index: index),
                                trailing: IconButton(
                                  tooltip: intl.deleteStop,
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => state.removeStop(index),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.saving) const LinearProgressIndicator(),
                if (!state.readOnly)
                  FilledButton(
                    onPressed: switch (state.saving) {
                      true => null,
                      false => () => _save(context, state),
                    },
                    child: Text(switch (state.tripId) {
                      null => intl.registerTrip,
                      _ => intl.saveChanges,
                    }),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
