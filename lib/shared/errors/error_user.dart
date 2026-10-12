import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the application user module.
enum UserError {
  /// A profile name must be supplied.
  nameRequired,

  /// A profile email must be supplied.
  emailRequired,

  /// The profile email format is invalid.
  invalidEmail,

  /// Another account already uses this email.
  emailAlreadyRegistered,

  /// A database or secure storage operation failed unexpectedly.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      UserError.nameRequired => intl.nameRequired,
      UserError.emailRequired => intl.emailRequired,
      UserError.invalidEmail => intl.invalidEmail,
      UserError.emailAlreadyRegistered => intl.emailAlreadyRegistered,
      UserError.unexpected => intl.unexpectedError,
    };
  }
}
