/// Application-wide constants for configuration and behavior.
abstract final class AppConstants {
  static const String appName = 'CareWell';

  /// Default backend URL for local development (ASP.NET Core http profile).
  ///
  /// Use `10.0.2.2` instead of `localhost` when running on Android emulator.
  static const String defaultBaseUrl = 'http://localhost:5011';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const String jsonContentType = 'application/json';
  static const String acceptJson = 'application/json';

  static const String bearerScheme = 'Bearer';
}
