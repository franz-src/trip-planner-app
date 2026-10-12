import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application trip module.
enum AppTripError {
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
      AppTripError.titleRequired => intl.tripTitleRequired,
      AppTripError.groupEmpty => intl.groupEmpty,
      AppTripError.stopsEmpty => intl.stopsEmpty,
      AppTripError.invalidPerson => intl.ageInvalid,
      AppTripError.invalidStop => intl.errorAddStopMsg,
      AppTripError.invalidDates => intl.endDateError,
      AppTripError.concludedTrip => intl.concludedTrips,
      AppTripError.invalidTrip ||
      AppTripError.notFound ||
      AppTripError.unexpected => intl.unexpectedError,
    };
  }
}
