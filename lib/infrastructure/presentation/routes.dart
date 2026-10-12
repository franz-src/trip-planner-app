import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/login/login_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/register/register_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/home/home_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/map/trip_map_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/map/trip_map_arguments.dart';
import 'package:trip_planner/infrastructure/presentation/features/startup/startup_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/settings/settings_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/list/trip_list_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/editor/trip_editor_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/details/trip_details_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/stop_details/stop_details_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/booklet/trip_booklet_screen.dart';

/// Route paths used by the application.
abstract final class AppRoutes {
  /// Home route.
  static const String home = '/home';

  /// Startup route.
  static const String startup = '/startup';

  /// Full-screen destination or draft map route.
  static const String map = '/map';

  /// Saved itinerary map route pattern.
  static const String tripMap = '/trips/:tripId/map';

  /// Returns the full-screen map route for a trip.
  static String tripMapPath(int id) => '$trips/$id/map';

  /// Login route.
  static const String login = '/login';

  /// Account registration route.
  static const String register = '/register';

  /// Application preferences and current-account route.
  static const String settings = '/settings';

  /// Current user's trip list route.
  static const String trips = '/trips';

  /// Trip creation route.
  static const String tripCreate = '/trips/new';

  /// Trip editing route pattern.
  static const String tripEdit = '/trips/:tripId/edit';

  /// Returns the editing route for a trip.
  static String tripEditPath(int id) => '$trips/$id/edit';

  /// Trip details route pattern.
  static const String tripDetails = '/trips/:tripId';

  /// Stop details route pattern.
  static const String stopDetails = '/trips/:tripId/stops/:stopId';

  /// Trip booklet route pattern.
  static const String tripBooklet = '/trips/:tripId/booklet';

  /// Returns the details route for a trip.
  static String tripDetailsPath(int id) => '$trips/$id';

  /// Returns the details route for a trip stop.
  static String stopDetailsPath(int tripId, int stopId) =>
      '$trips/$tripId/stops/$stopId';

  /// Returns the booklet route for a trip.
  static String tripBookletPath(int id) => '$trips/$id/booklet';
}

String? _localDestination(String? value) {
  final uri = Uri.tryParse(value ?? '');
  if (uri == null || uri.hasScheme || uri.hasAuthority) {
    return null;
  }

  final path = uri.path;
  if ([
        AppRoutes.home,
        AppRoutes.trips,
        AppRoutes.tripCreate,
        AppRoutes.settings,
        AppRoutes.map,
        AppRoutes.login,
        AppRoutes.register,
      ].contains(path) ||
      RegExp(
        r'^/trips/[1-9]\d*(?:/(?:edit|map|booklet|stops/[1-9]\d*))?$',
      ).hasMatch(path)) {
    return uri.toString();
  }

  return null;
}

String _authenticatedDestination(String? from) {
  final destination = _localDestination(from);
  if (destination != null &&
      ![
        AppRoutes.login,
        AppRoutes.register,
      ].contains(Uri.parse(destination).path)) {
    return destination;
  }

  return AppRoutes.home;
}

LatLng? _mapPosition(GoRouterState state) {
  final latitude = double.tryParse(state.uri.queryParameters['lat'] ?? '');
  final longitude = double.tryParse(state.uri.queryParameters['lon'] ?? '');
  if (latitude == null ||
      longitude == null ||
      !latitude.isFinite ||
      !longitude.isFinite ||
      latitude.abs() > 90 ||
      longitude.abs() > 180) {
    return null;
  }

  return LatLng(latitude, longitude);
}

/// Creates the router bound to the current application session.
GoRouter newAppRouter(AppState appState) {
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: AppRoutes.home,
    refreshListenable: appState,
    redirect: (context, state) {
      final path = state.uri.path;
      if (appState.loading || appState.initializationError != null) {
        if (path == AppRoutes.startup) {
          return null;
        }

        return Uri(
          path: AppRoutes.startup,
          queryParameters: {'from': state.uri.toString()},
        ).toString();
      }

      if (path == AppRoutes.startup) {
        final from =
            _localDestination(state.uri.queryParameters['from']) ??
            AppRoutes.home;
        if (appState.user != null) {
          return _authenticatedDestination(from);
        }

        if ([
          AppRoutes.login,
          AppRoutes.register,
        ].contains(Uri.parse(from).path)) {
          return from;
        }

        return Uri(
          path: AppRoutes.login,
          queryParameters: {'from': from},
        ).toString();
      }

      final public = path == AppRoutes.login || path == AppRoutes.register;
      if (appState.user == null && !public) {
        return Uri(
          path: AppRoutes.login,
          queryParameters: {'from': state.uri.toString()},
        ).toString();
      }

      if (appState.user != null && public) {
        return _authenticatedDestination(state.uri.queryParameters['from']);
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => context.go(AppRoutes.home),
          child: Text(AppLocalizations.of(context).home),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.startup,
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) => TripMapScreen(
          arguments: switch (state.extra) {
            TripMapArguments arguments => arguments,
            _ => null,
          },
          initialPosition: _mapPosition(state),
          locationName: state.uri.queryParameters['name'],
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tripCreate,
                builder: (context, state) => const TripEditorScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.trips,
                builder: (context, state) => const TripListScreen(),
                routes: [
                  GoRoute(
                    path: ':tripId/edit',
                    builder: (context, state) => TripEditorScreen(
                      tripId:
                          int.tryParse(state.pathParameters['tripId'] ?? '') ??
                          -1,
                    ),
                  ),
                  GoRoute(
                    path: ':tripId',
                    builder: (context, state) => TripDetailsScreen(
                      tripId:
                          int.tryParse(state.pathParameters['tripId'] ?? '') ??
                          -1,
                    ),
                    routes: [
                      GoRoute(
                        path: 'stops/:stopId',
                        builder: (context, state) => StopDetailsScreen(
                          tripId:
                              int.tryParse(
                                state.pathParameters['tripId'] ?? '',
                              ) ??
                              -1,
                          stopId:
                              int.tryParse(
                                state.pathParameters['stopId'] ?? '',
                              ) ??
                              -1,
                        ),
                      ),
                      GoRoute(
                        path: 'booklet',
                        builder: (context, state) => TripBookletScreen(
                          tripId:
                              int.tryParse(
                                state.pathParameters['tripId'] ?? '',
                              ) ??
                              -1,
                        ),
                      ),
                      GoRoute(
                        path: 'map',
                        parentNavigatorKey: rootKey,
                        builder: (context, state) => TripMapScreen(
                          tripId:
                              int.tryParse(
                                state.pathParameters['tripId'] ?? '',
                              ) ??
                              -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: intl.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_location_alt_outlined),
            label: intl.newTrip,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt),
            label: intl.yourTrips,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: intl.preferences,
          ),
        ],
      ),
    );
  }
}
