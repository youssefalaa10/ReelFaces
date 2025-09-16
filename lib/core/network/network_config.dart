class NetworkConfig {
  // TMDb API Configuration
  static const String _defaultApiKey = 'YOUR_TMDB_API_KEY_HERE';
  static const String _defaultLanguage = 'en-US';

  // Current configuration
  static String _currentApiKey = _defaultApiKey;
  static String _currentLanguage = _defaultLanguage;

  // Getters
  static String get apiKey => _currentApiKey;
  static String get language => _currentLanguage;

  // Setters
  static void setApiKey(String apiKey) {
    _currentApiKey = apiKey;
  }

  static void setLanguage(String language) {
    _currentLanguage = language;
  }

  // Validation
  static bool get isApiKeyValid =>
      _currentApiKey.isNotEmpty && _currentApiKey != _defaultApiKey;

  static bool get isLanguageValid => _currentLanguage.isNotEmpty;

  // Reset to defaults
  static void reset() {
    _currentApiKey = _defaultApiKey;
    _currentLanguage = _defaultLanguage;
  }

  // Environment-specific configuration
  static void configureForDevelopment() {
    // Add development-specific configuration here
    setLanguage('en-US');
  }

  static void configureForProduction() {
    // Add production-specific configuration here
    setLanguage('en-US');
  }

  // Helper method to get full image URL
  static String getImageUrl(String imagePath, {String size = 'w500'}) {
    if (imagePath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$imagePath';
  }

  // Helper method to get profile image URL
  static String getProfileImageUrl(String imagePath, {String size = 'w342'}) {
    return getImageUrl(imagePath, size: size);
  }

  // Helper method to get backdrop image URL
  static String getBackdropImageUrl(String imagePath, {String size = 'w1280'}) {
    return getImageUrl(imagePath, size: size);
  }
}
