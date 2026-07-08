class AppSettings {
  final int? id;
  final String userId;
  final bool biometricEnabled;
  final bool pinEnabled;
  final String themeMode;

  AppSettings({
    this.id,
    required this.userId,
    required this.biometricEnabled,
    required this.pinEnabled,
    required this.themeMode,
  });
}
