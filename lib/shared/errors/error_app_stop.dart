import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application stop module.
enum AppStopError {
  /// A stop's location must be supplied.
  locationRequired,

  /// The arrival date must be supplied.
  startDateRequired,

  /// The departure date must be supplied.
  endDateRequired,

  /// Dates must be valid and departure cannot precede arrival.
  invalidDates,

  /// Coordinates are outside geographic bounds.
  invalidCoordinates,

  /// A location or route service failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      AppStopError.startDateRequired => intl.startDateRequired,
      AppStopError.endDateRequired => intl.endDateRequired,
      AppStopError.invalidDates => intl.endDateError,
      AppStopError.locationRequired ||
      AppStopError.invalidCoordinates => intl.errorAddStopMsg,
      AppStopError.unexpected => intl.unexpectedError,
    };
  }
}
