/// Keys used to persist application data.
abstract final class StorageKeys {
  /// Secure storage key for the current application user.
  static const String appUserStorageKey = 'app_user';

  /// Preference key for the selected language code.
  static const String languageStorageKey = 'selected_language';

  /// Preference key for the canonical theme code.
  static const String themeStorageKey = 'theme_mode';
}
