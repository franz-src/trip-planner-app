import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/infrastructure/infrastructure.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/routes.dart';
import 'infrastructure/presentation/app/intl/app_localizations.dart';
import 'infrastructure/presentation/app/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _AppBootstrap());
}

class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap();

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  late Future<void> _startup;
  AppState? _appState;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _startup = initialize().then((_) {
      if (mounted) {
        _appState = AppState();
      }
    });
    _startup.ignore();
  }

  @override
  void dispose() {
    _appState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startup,
      builder: (context, snapshot) {
        final appState = _appState;
        if (snapshot.connectionState == ConnectionState.done &&
            appState != null) {
          return ChangeNotifierProvider.value(
            value: appState,
            child: const TripPlannerApp(),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: Scaffold(
            body: Center(
              child: switch (snapshot.hasError) {
                true => FilledButton(
                  onPressed: () => setState(_start),
                  child: const Text('Try again'),
                ),
                false => const CircularProgressIndicator(),
              },
            ),
          ),
        );
      },
    );
  }
}

class TripPlannerApp extends StatefulWidget {
  const TripPlannerApp({super.key});

  @override
  State<TripPlannerApp> createState() => _TripPlannerAppState();
}

class _TripPlannerAppState extends State<TripPlannerApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = newAppRouter(context.read<AppState>());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp.router(
      routerConfig: _router,
      locale: appState.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appState.themeMode,
    );
  }
}
