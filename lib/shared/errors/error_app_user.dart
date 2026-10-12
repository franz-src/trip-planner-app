import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application user module.
enum AppUserError {
  /// Reading or decoding the stored application user failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      AppUserError.unexpected => intl.unexpectedError,
    };
  }
}
