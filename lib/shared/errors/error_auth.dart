import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Errors returned by the authentication module.
enum AuthError {
  /// No user exists for the supplied email or the password does not match.
  invalidCredentials,

  /// Registration requires a nonblank name.
  nameRequired,

  /// An email address must be supplied.
  emailRequired,

  /// The supplied email address has an invalid format.
  invalidEmail,

  /// A password must be supplied.
  passwordRequired,

  /// Registration passwords must contain at least eight characters.
  passwordTooShort,

  /// The password exceeds bcrypt's maximum of 72 UTF-8 bytes.
  passwordTooLong,

  /// Another account already uses the registration email address.
  emailAlreadyRegistered,

  /// An unexpected database, password hashing, or session storage failure occurred.
  unexpected;

  /// Returns the localized message for this error.
  String translate(AppLocalizations intl) {
    return switch (this) {
      AuthError.invalidCredentials => intl.emailPasswordIncorrect,
      AuthError.nameRequired => intl.nameRequired,
      AuthError.emailRequired => intl.emailRequired,
      AuthError.invalidEmail => intl.invalidEmail,
      AuthError.passwordRequired => intl.passwordRequired,
      AuthError.passwordTooShort => intl.passwordTooShort,
      AuthError.passwordTooLong => intl.passwordTooLong,
      AuthError.emailAlreadyRegistered => intl.emailAlreadyRegistered,
      AuthError.unexpected => intl.unexpectedError,
    };
  }
}
