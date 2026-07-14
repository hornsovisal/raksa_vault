class AppSettings {
  final int? id;
  final String userId;
  final bool biometricEnabled;
  final bool pinEnabled;

  AppSettings({
    this.id,
    required this.userId,
    required this.biometricEnabled,
    required this.pinEnabled,
  });
}
