import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application stop module.
enum StopError {
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

  /// Device location services are disabled.
  locationServicesDisabled,

  /// Permission to access device location was denied.
  locationPermissionDenied,

  /// A location or route service failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      StopError.startDateRequired => intl.startDateRequired,
      StopError.endDateRequired => intl.endDateRequired,
      StopError.invalidDates => intl.endDateError,
      StopError.locationServicesDisabled => intl.locationServicesDisabled,
      StopError.locationPermissionDenied => intl.locationPermissionDenied,
      StopError.locationRequired ||
      StopError.invalidCoordinates => intl.errorAddStopMsg,
      StopError.unexpected => intl.unexpectedError,
    };
  }
}
