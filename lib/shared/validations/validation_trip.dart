import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';
import 'package:trip_planner/shared/validations/validation_person.dart';
import 'package:trip_planner/shared/validations/validation_stop.dart';

/// Validation rules for application trips.
abstract final class TripRules {
  /// Validates the fields required to save a trip.
  static TripError? validateTrip(Trip trip) {
    if (trip.userId == null || trip.userId! <= 0) {
      return TripError.invalidTrip;
    }

    if (trip.title.trim().isEmpty) {
      return TripError.titleRequired;
    }

    if (trip.group.isEmpty) {
      return TripError.groupEmpty;
    }

    if (trip.stops.isEmpty) {
      return TripError.stopsEmpty;
    }

    for (final person in trip.group) {
      if (PersonRules.validatePerson(person) != null) {
        return TripError.invalidPerson;
      }
    }

    DateTime? previousDeparture;
    for (final stop in trip.stops) {
      if (StopRules.validateStop(stop) != null) {
        return TripError.invalidStop;
      }

      final arrival = StopRules.parseDate(stop.startDate)!;
      final departure = StopRules.parseDate(stop.endDate)!;
      if (previousDeparture != null && arrival.isBefore(previousDeparture)) {
        return TripError.invalidDates;
      }

      previousDeparture = departure;
    }

    if (trip.startDate != trip.stops.first.startDate ||
        trip.endDate != trip.stops.last.endDate ||
        trip.transport.trim().isEmpty) {
      return TripError.invalidTrip;
    }

    return null;
  }
}
