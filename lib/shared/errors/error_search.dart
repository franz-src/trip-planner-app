import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by destination search.
enum SearchError {
  /// The destination service failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) => intl.unexpectedError;
}
