import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/list/trip_list_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripListState(context.read<AppState>()),
      child: const _TripListScreen(),
    );
  }
}

class _TripListScreen extends StatelessWidget {
  const _TripListScreen();

  Future<void> _openDetails(
    BuildContext context,
    TripListState state,
    Trip trip,
  ) async {
    final id = trip.id;
    if (id == null) {
      return;
    }

    await context.push(AppRoutes.tripDetailsPath(id));
    if (context.mounted) {
      await state.loadTrips();
    }
  }

  Future<void> _openEditor(
    BuildContext context,
    TripListState state, {
    Trip? trip,
  }) async {
    var route = AppRoutes.tripCreate;
    if (trip?.id != null) {
      route = AppRoutes.tripEditPath(trip!.id!);
    }

    await context.push(route);
    if (context.mounted) {
      await state.loadTrips();
    }
  }

  Future<void> _performAction(
    BuildContext context,
    TripListState state,
    Trip trip, {
    bool conclude = false,
  }) async {
    final intl = AppLocalizations.of(context);
    var title = intl.delete;
    var message = trip.title;
    if (conclude) {
      title = intl.concludeTrip;
      message = intl.tripEndedOn(trip.title, trip.endDate);
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(intl.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(intl.ok),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final result = await switch (conclude) {
      true => state.concludeTrip(trip),
      false => state.deleteTrip(trip),
    };
    if (!context.mounted) {
      return;
    }

    if (result case Failure(:final error)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.translate(AppLocalizations.of(context)))),
      );
    }
  }

  Widget _section(
    BuildContext context,
    TripListState state,
    String title,
    List<Trip> trips,
    String emptyMessage,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final intl = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Text('${trips.length}'),
          ],
        ),
        if (trips.isEmpty)
          Padding(padding: const EdgeInsets.all(25), child: Text(emptyMessage)),
        for (final trip in trips)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Builder(
              builder: (context) {
                var color = theme.colorScheme.primary;
                if (!trip.concluded && state.isExpired(trip)) {
                  color = Colors.orange;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: ListTile(
                    leading: Icon(icon, color: color),
                    title: Text(
                      trip.title,
                      style: TextStyle(
                        color: color,
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Text('${trip.startDate} - ${trip.endDate}'),
                    onTap: switch (state.isBusy(trip)) {
                      true => null,
                      false => () => _openDetails(context, state, trip),
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.isBusy(trip))
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          ),
                        if (!state.isBusy(trip) &&
                            !trip.concluded &&
                            state.isExpired(trip))
                          IconButton(
                            tooltip: intl.markAsConcluded,
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.orange,
                            ),
                            onPressed: () => _performAction(
                              context,
                              state,
                              trip,
                              conclude: true,
                            ),
                          ),
                        if (!state.isBusy(trip))
                          IconButton(
                            tooltip: intl.delete,
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                _performAction(context, state, trip),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(intl.yourTrips),
        actions: [
          IconButton(
            tooltip: intl.preferences,
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Consumer<TripListState>(
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
                    onPressed: state.loadTrips,
                    child: Text(intl.tryAgain),
                  ),
                ],
              ),
            );
          }

          if (state.signedOut) {
            return Center(
              child: FilledButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(intl.signIn),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: state.loadTrips,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(25),
              children: [
                _section(
                  context,
                  state,
                  intl.activeTrips,
                  state.trips.where((trip) => !trip.concluded).toList(),
                  intl.noActiveTrips,
                  Icons.flight_takeoff,
                ),
                const SizedBox(height: 25),
                _section(
                  context,
                  state,
                  intl.concludedTrips,
                  state.trips.where((trip) => trip.concluded).toList(),
                  intl.noConcludedTrips,
                  Icons.done_all,
                ),
                FilledButton.icon(
                  onPressed: () => _openEditor(context, state),
                  icon: const Icon(Icons.add_location_alt),
                  label: Text(intl.newTrip),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
