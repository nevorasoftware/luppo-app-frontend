class AppConfig {
  static const String _rawApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://luppo-app-backend-production.up.railway.app/api/v1',
  );

  static String get apiBaseUrl {
    final trimmed = _rawApiBaseUrl.endsWith('/')
        ? _rawApiBaseUrl.substring(0, _rawApiBaseUrl.length - 1)
        : _rawApiBaseUrl;
    if (!trimmed.endsWith('/api/v1')) {
      return '$trimmed/api/v1';
    }
    return trimmed;
  }

  static const String appName = 'Luppo';
  static const String appTagline = 'Ventas en movimiento';
}
