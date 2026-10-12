import 'package:go_router/go_router.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/login/login_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/register/register_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/settings/settings_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/list/trip_list_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/editor/trip_editor_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/details/trip_details_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/stop_details/stop_details_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/trip/booklet/trip_booklet_screen.dart';

/// Route paths used by the application.
abstract final class AppRoutes {
  /// Initial login route.
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

/// Router for the new application presentation.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.trips,
      builder: (context, state) => const TripListScreen(),
    ),
    GoRoute(
      path: AppRoutes.tripCreate,
      builder: (context, state) => const TripEditorScreen(),
    ),
    GoRoute(
      path: AppRoutes.tripEdit,
      builder: (context, state) => TripEditorScreen(
        tripId: int.tryParse(state.pathParameters['tripId'] ?? '') ?? -1,
      ),
    ),
    GoRoute(
      path: AppRoutes.tripDetails,
      builder: (context, state) => TripDetailsScreen(
        tripId: int.tryParse(state.pathParameters['tripId'] ?? '') ?? -1,
      ),
    ),
    GoRoute(
      path: AppRoutes.stopDetails,
      builder: (context, state) => StopDetailsScreen(
        tripId: int.tryParse(state.pathParameters['tripId'] ?? '') ?? -1,
        stopId: int.tryParse(state.pathParameters['stopId'] ?? '') ?? -1,
      ),
    ),
    GoRoute(
      path: AppRoutes.tripBooklet,
      builder: (context, state) => TripBookletScreen(
        tripId: int.tryParse(state.pathParameters['tripId'] ?? '') ?? -1,
      ),
    ),
  ],
);
