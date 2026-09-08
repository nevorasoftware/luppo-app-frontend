class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  static const String appName = 'Luppo';
  static const String appTagline = 'Ventas en movimiento';
}
