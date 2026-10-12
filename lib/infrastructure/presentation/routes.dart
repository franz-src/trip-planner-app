import 'package:go_router/go_router.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/login/login_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/auth/register/register_screen.dart';
import 'package:trip_planner/infrastructure/presentation/features/settings/settings_screen.dart';

/// Route paths used by the application.
abstract final class AppRoutes {
  /// Initial login route.
  static const String login = '/login';

  /// Account registration route.
  static const String register = '/register';

  /// Application preferences and current-account route.
  static const String settings = '/settings';
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
  ],
);
