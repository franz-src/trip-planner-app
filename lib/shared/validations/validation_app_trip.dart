import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/shared/errors/error_app_trip.dart';
import 'package:trip_planner/shared/validations/validation_app_person.dart';
import 'package:trip_planner/shared/validations/validation_app_stop.dart';

/// Validation rules for application trips.
abstract final class AppTripRules {
  /// Validates the fields required to save a trip.
  static AppTripError? validateTrip(Trip trip) {
    if (trip.userId == null || trip.userId! <= 0) {
      return AppTripError.invalidTrip;
    }

    if (trip.title.trim().isEmpty) {
      return AppTripError.titleRequired;
    }

    if (trip.group.isEmpty) {
      return AppTripError.groupEmpty;
    }

    if (trip.stops.isEmpty) {
      return AppTripError.stopsEmpty;
    }

    for (final person in trip.group) {
      if (AppPersonRules.validatePerson(person) != null) {
        return AppTripError.invalidPerson;
      }
    }

    DateTime? previousDeparture;
    for (final stop in trip.stops) {
      if (AppStopRules.validateStop(stop) != null) {
        return AppTripError.invalidStop;
      }

      final arrival = AppStopRules.parseDate(stop.startDate)!;
      final departure = AppStopRules.parseDate(stop.endDate)!;
      if (previousDeparture != null && arrival.isBefore(previousDeparture)) {
        return AppTripError.invalidDates;
      }

      previousDeparture = departure;
    }

    if (trip.startDate != trip.stops.first.startDate ||
        trip.endDate != trip.stops.last.endDate ||
        trip.transport.trim().isEmpty) {
      return AppTripError.invalidTrip;
    }

    return null;
  }
}
