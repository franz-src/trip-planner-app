import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the settings module.
enum SettingsError {
  /// Reading, decoding or saving a preference failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      SettingsError.unexpected => intl.unexpectedError,
    };
  }
}
