import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/home/home_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeState(),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final user = context.select<AppState, String>(
      (state) => state.user?.name ?? '',
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'TP',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.welcomeUser(user),
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        intl.planYourNextAdventure,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Consumer<HomeState>(
              builder: (context, state, child) => Column(
                children: [
                  TextField(
                    controller: state.controllerSearch,
                    onChanged: state.search,
                    decoration: InputDecoration(
                      hintText: intl.searchDestinations,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: theme.colorScheme.tertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: switch (state.query.isEmpty) {
                        true => null,
                        false => IconButton(
                          onPressed: state.clearSearch,
                          icon: const Icon(Icons.clear),
                        ),
                      },
                    ),
                  ),
                  if (state.loading)
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          Text(intl.searching),
                        ],
                      ),
                    ),
                  if (state.error case final error?)
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text(error.translate(intl)),
                          TextButton(
                            onPressed: () => state.search(state.query),
                            child: Text(intl.tryAgain),
                          ),
                        ],
                      ),
                    ),
                  if (!state.loading &&
                      state.error == null &&
                      state.query.isNotEmpty &&
                      state.results.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(intl.noResultsFound),
                    ),
                  for (final result in state.results)
                    Card(
                      color: theme.colorScheme.tertiary,
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(result.displayName),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          Uri(
                            path: AppRoutes.map,
                            queryParameters: {
                              'lat': result.position.latitude.toString(),
                              'lon': result.position.longitude.toString(),
                              'name': result.displayName,
                            },
                          ).toString(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
