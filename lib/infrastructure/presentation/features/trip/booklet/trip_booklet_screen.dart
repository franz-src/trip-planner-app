import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/booklet/trip_booklet_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';
import 'package:trip_planner/shared/errors/error_trip_booklet.dart';

class TripBookletScreen extends StatelessWidget {
  const TripBookletScreen({super.key, required this.tripId});

  final int tripId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: ValueKey(tripId),
      create: (_) => TripBookletState(context.read<AppState>(), tripId),
      child: const _TripBookletScreen(),
    );
  }
}

class _TripBookletScreen extends StatelessWidget {
  const _TripBookletScreen();

  Future<void> _run(
    BuildContext context,
    Future<Result<void, TripBookletError>> operation,
  ) async {
    final result = await operation;
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
      appBar: AppBar(title: Text(intl.createBooklet)),
      body: Consumer<TripBookletState>(
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

          if (!trip.concluded) {
            return Center(
              child: Text(TripBookletError.notConcluded.translate(intl)),
            );
          }

          final document = state.document;
          if (document != null) {
            return Column(
              children: [
                TextButton.icon(
                  onPressed: state.editMemories,
                  icon: const Icon(Icons.edit),
                  label: Text(intl.edit),
                ),
                Expanded(
                  child: PdfPreview(
                    build: (_) async => document,
                    pdfFileName: 'trip-${trip.id}.pdf',
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                  ),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(25),
            children: [
              Text(
                trip.title,
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                intl.groupMembersPhotos,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AbsorbPointer(
                absorbing: state.generating || state.picking,
                child: Column(
                  children: [
                    for (var index = 0; index < trip.group.length; index++)
                      Card(
                        child: ListTile(
                          title: Text(trip.group[index].name),
                          leading: switch (state.personPhoto(index)) {
                            null => const Icon(Icons.person),
                            final bytes => Image.memory(
                              bytes,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  const Icon(Icons.broken_image),
                            ),
                          },
                          trailing: IconButton(
                            tooltip: intl.addPhoto,
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () =>
                                _run(context, state.pickPersonPhoto(index)),
                          ),
                        ),
                      ),
                    for (var index = 0; index < trip.stops.length; index++)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                trip.stops[index].location,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                controller: state.descriptionController(index),
                                decoration: InputDecoration(
                                  labelText: intl.writeExperience,
                                ),
                                minLines: 3,
                                maxLines: null,
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (
                                    var photoIndex = 0;
                                    photoIndex < state.stopPhotos(index).length;
                                    photoIndex++
                                  )
                                    SizedBox(
                                      width: 120,
                                      child: Column(
                                        children: [
                                          Image.memory(
                                            state.stopPhotos(index)[photoIndex],
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    const Icon(
                                                      Icons.broken_image,
                                                    ),
                                          ),
                                          IconButton(
                                            tooltip: intl.delete,
                                            icon: const Icon(Icons.close),
                                            onPressed: () =>
                                                state.removeStopPhoto(
                                                  index,
                                                  photoIndex,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    _run(context, state.pickStopPhoto(index)),
                                icon: const Icon(Icons.add_photo_alternate),
                                label: Text(intl.addPhoto),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.generating || state.picking)
                const LinearProgressIndicator(),
              FilledButton.icon(
                onPressed: switch (state.generating || state.picking) {
                  true => null,
                  false => () => _run(context, state.generate(intl)),
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(intl.generateBooklet),
              ),
            ],
          );
        },
      ),
    );
  }
}
