import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/infrastructure/presentation/features/startup/startup_state.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StartupState(context.read<AppState>()),
      child: const _StartupScreen(),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context);

    return Scaffold(
      body: Consumer<StartupState>(
        builder: (context, state, child) {
          final error = state.error;
          if (!state.loading && error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error.translate(intl)),
                  FilledButton(
                    onPressed: state.retry,
                    child: Text(intl.tryAgain),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
