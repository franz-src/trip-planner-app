import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application person module.
enum PersonError {
  /// A group member's name must be supplied.
  nameRequired,

  /// A group member's age must be supplied.
  ageRequired,

  /// Age must be a nonnegative integer.
  invalidAge;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      PersonError.nameRequired => intl.nameRequired,
      PersonError.ageRequired => intl.ageRequired,
      PersonError.invalidAge => intl.ageInvalid,
    };
  }
}
