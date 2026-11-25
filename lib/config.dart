/// Base URL of the Django REST Framework backend.
///
/// Defaults to `http://10.0.2.2:8000`, the host machine's loopback address
/// as seen from an Android emulator. Override it with
/// `--dart-define=API_BASE_URL=http://localhost:8000` when testing on Chrome
/// or another web browser.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
