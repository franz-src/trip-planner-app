import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/stop_details/stop_details_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';

class StopDetailsScreen extends StatelessWidget {
  const StopDetailsScreen({
    super.key,
    required this.tripId,
    required this.stopId,
  });

  final int tripId;
  final int stopId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey('$tripId:$stopId'),
      create: (_) => StopDetailsState(context.read<AppState>(), tripId, stopId),
      child: const _StopDetailsScreen(),
    );
  }
}

class _StopDetailsScreen extends StatelessWidget {
  const _StopDetailsScreen();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(intl.destination)),
      body: Consumer<StopDetailsState>(
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
                    onPressed: state.loadStop,
                    child: Text(intl.tryAgain),
                  ),
                ],
              ),
            );
          }

          final stop = state.stop;
          if (stop == null) {
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
              Text(
                stop.location,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(intl.dates),
                subtitle: Text('${stop.startDate} - ${stop.endDate}'),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text('${intl.latitude}: ${stop.latitude}'),
                subtitle: Text('${intl.longitude}: ${stop.longitude}'),
              ),
              Text(
                intl.experiences,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              for (final experience in stop.stopExperiences)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(experience.experience),
                ),
            ],
          );
        },
      ),
    );
  }
}
