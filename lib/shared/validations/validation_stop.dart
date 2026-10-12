import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/shared/errors/error_stop.dart';

/// Validation rules for itinerary stops.
abstract final class StopRules {
  /// Parses a valid date in the existing day/month/year format.
  static DateTime? parseDate(String text) {
    final parts = text.split('/');
    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null ||
        month == null ||
        year == null ||
        year < 1 ||
        year > 9999) {
      return null;
    }

    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year) {
      return null;
    }

    return date;
  }

  /// Validates a stop's location, dates, and coordinates.
  static StopError? validateStop(Stop stop) {
    if (stop.location.trim().isEmpty) {
      return StopError.locationRequired;
    }

    if (stop.startDate.trim().isEmpty) {
      return StopError.startDateRequired;
    }

    if (stop.endDate.trim().isEmpty) {
      return StopError.endDateRequired;
    }

    final start = parseDate(stop.startDate);
    final end = parseDate(stop.endDate);
    if (start == null || end == null || end.isBefore(start)) {
      return StopError.invalidDates;
    }

    if (!stop.latitude.isFinite ||
        !stop.longitude.isFinite ||
        stop.latitude.abs() > 90 ||
        stop.longitude.abs() > 180) {
      return StopError.invalidCoordinates;
    }

    return null;
  }
}
