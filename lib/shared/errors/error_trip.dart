import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application trip module.
enum TripError {
  /// A trip title must be supplied.
  titleRequired,

  /// A trip must contain a travel group.
  groupEmpty,

  /// A trip must contain stops.
  stopsEmpty,

  /// A travel group member is invalid.
  invalidPerson,

  /// A destination or its coordinates are invalid.
  invalidStop,

  /// Itinerary dates are invalid or out of order.
  invalidDates,

  /// A trip has already been concluded.
  concludedTrip,

  /// The trip identifiers are invalid.
  invalidTrip,

  /// The requested trip was not found for the user.
  notFound,

  /// A database operation failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      TripError.titleRequired => intl.tripTitleRequired,
      TripError.groupEmpty => intl.groupEmpty,
      TripError.stopsEmpty => intl.stopsEmpty,
      TripError.invalidPerson => intl.ageInvalid,
      TripError.invalidStop => intl.errorAddStopMsg,
      TripError.invalidDates => intl.endDateError,
      TripError.concludedTrip => intl.concludedTrips,
      TripError.invalidTrip ||
      TripError.notFound ||
      TripError.unexpected => intl.unexpectedError,
    };
  }
}
