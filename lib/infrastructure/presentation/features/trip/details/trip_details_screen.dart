import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/details/trip_details_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey(tripId),
      create: (_) => TripDetailsState(context.read<AppState>(), tripId),
      child: const _TripDetailsScreen(),
    );
  }
}

class _TripDetailsScreen extends StatelessWidget {
  const _TripDetailsScreen();

  Future<void> _delete(BuildContext context, TripDetailsState state) async {
    final trip = state.trip;
    if (trip == null) {
      return;
    }

    final intl = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(intl.deleteTrip),
        content: Text(intl.deleteTripConfirm(trip.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(intl.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(intl.delete),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) {
      return;
    }

    final result = await state.deleteTrip();
    if (!context.mounted) {
      return;
    }

    switch (result) {
      case Success():
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go(AppRoutes.trips);
        }
      case Failure(:final error):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.translate(intl))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(intl.tripDetails)),
      body: Consumer<TripDetailsState>(
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
                    onPressed: state.loadTrip,
                    child: Text(intl.tryAgain),
                  ),
                ],
              ),
            );
          }

          final trip = state.trip;
          if (trip == null) {
            return Center(
              child: FilledButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(intl.signIn),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(25),
            children: [
              TextButton.icon(
                onPressed: () => context.push(AppRoutes.tripMapPath(trip.id!)),
                icon: const Icon(Icons.map),
                label: Text(intl.fullscreenMap),
              ),
              Text(
                trip.title,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text('${trip.startDate} - ${trip.endDate} · ${trip.transport}'),
              if (trip.concluded) Chip(label: Text(intl.concluded)),
              if (trip.mapImage != null && trip.mapImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
                    trip.mapImage!,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(intl.mapNotAvailable),
                    ),
                  ),
                ),
              if (trip.mapImage == null || trip.mapImage!.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(intl.mapNotAvailable),
                ),
              Text(
                intl.travelGroup,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              for (final person in trip.group)
                Card(
                  color: theme.colorScheme.tertiary,
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(person.name),
                    subtitle: Text('${person.age} ${intl.yearsOld}'),
                  ),
                ),
              Text(
                intl.tripStops,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (trip.stops.isEmpty) Text(intl.noStopsAdded),
              for (final stop in trip.stops)
                Card(
                  color: theme.colorScheme.tertiary,
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(stop.location),
                    subtitle: Text('${stop.startDate} - ${stop.endDate}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      AppRoutes.stopDetailsPath(trip.id!, stop.id!),
                    ),
                  ),
                ),
              if (!trip.concluded)
                FilledButton.icon(
                  onPressed: switch (state.deleting) {
                    true => null,
                    false => () async {
                      await context.push(AppRoutes.tripEditPath(trip.id!));
                      if (context.mounted) {
                        await state.loadTrip();
                      }
                    },
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(intl.edit),
                ),
              if (trip.concluded)
                FilledButton.icon(
                  onPressed: () =>
                      context.push(AppRoutes.tripBookletPath(trip.id!)),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: Text(intl.createBooklet),
                ),
              if (state.deleting) const LinearProgressIndicator(),
              OutlinedButton.icon(
                onPressed: switch (state.deleting) {
                  true => null,
                  false => () => _delete(context, state),
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: Text(intl.deleteTrip),
              ),
            ],
          );
        },
      ),
    );
  }
}
