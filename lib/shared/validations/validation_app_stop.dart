import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/shared/errors/error_app_stop.dart';

/// Validation rules for itinerary stops.
abstract final class AppStopRules {
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
  static AppStopError? validateStop(Stop stop) {
    if (stop.location.trim().isEmpty) {
      return AppStopError.locationRequired;
    }

    if (stop.startDate.trim().isEmpty) {
      return AppStopError.startDateRequired;
    }

    if (stop.endDate.trim().isEmpty) {
      return AppStopError.endDateRequired;
    }

    final start = parseDate(stop.startDate);
    final end = parseDate(stop.endDate);
    if (start == null || end == null || end.isBefore(start)) {
      return AppStopError.invalidDates;
    }

    if (!stop.latitude.isFinite ||
        !stop.longitude.isFinite ||
        stop.latitude.abs() > 90 ||
        stop.longitude.abs() > 180) {
      return AppStopError.invalidCoordinates;
    }

    return null;
  }
}
