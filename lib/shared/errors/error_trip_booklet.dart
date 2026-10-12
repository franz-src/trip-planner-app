import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the trip booklet feature.
enum TripBookletError {
  /// Every travel group member requires a photo.
  missingPersonPhotos,

  /// Every stop requires photos and a written description.
  missingStopData,

  /// Only concluded trips can be exported as a booklet.
  notConcluded,

  /// Image selection or PDF generation failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      TripBookletError.missingPersonPhotos => intl.addPhotosAllMembers,
      TripBookletError.missingStopData => intl.pleaseAddAllStopData,
      TripBookletError.notConcluded => intl.concludedTrips,
      TripBookletError.unexpected => intl.errorGeneratingPdf,
    };
  }
}
