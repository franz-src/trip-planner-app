import 'package:flutter/material.dart';
import 'package:trip_planner/infrastructure/presentation/app_state.dart';
import 'package:trip_planner/shared/errors/error_user.dart';

/// State for initial session restoration and retry.
class StartupState with ChangeNotifier {
  /// Default constructor.
  StartupState(this._appState) {
    _appState.addListener(notifyListeners);
  }

  final AppState _appState;

  /// Whether initial restoration is pending.
  bool get loading => _appState.loading;

  /// The current session restoration failure.
  UserError? get error => _appState.initializationError;

  /// Retries initial restoration.
  Future<void> retry() => _appState.retryInitialization();

  @override
  void dispose() {
    _appState.removeListener(notifyListeners);
    super.dispose();
  }
}
