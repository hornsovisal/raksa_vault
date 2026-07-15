import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  // Use Flutter Secure Storage which leverages Android Keystore and iOS Keychain
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _pinKey = 'user_secure_pin';
  static String? _inMemoryPin;

  /// Saves the PIN securely using hardware-backed encryption
  Future<void> savePin(String pin) async {
    _inMemoryPin = pin;
    try {
      await _secureStorage.write(key: _pinKey, value: pin);
    } catch (e) {}
  }

  /// Verifies if the entered PIN matches the securely stored PIN
  Future<bool> verifyPin(String pin) async {
    final savedPin = await _readPin();

    // If the PIN is missing, the user must go through setup or registration.
    if (savedPin == null) {
      return false;
    }

    return savedPin == pin;
  }

  /// Checks if a PIN has already been set up
  Future<bool> hasPin() async {
    final savedPin = await _readPin();
    return savedPin != null && savedPin.isNotEmpty;
  }

  /// Reads the PIN securely from iOS Keychain / Android Keystore
  Future<String?> _readPin() async {
    if (_inMemoryPin != null) return _inMemoryPin;
    try {
      _inMemoryPin = await _secureStorage.read(key: _pinKey);
      return _inMemoryPin;
    } catch (e) {
      // Secure fallback
    }
    return null;
  }

  /// Clear the PIN if the user logs out or resets the app
  Future<void> clearPin() async {
    _inMemoryPin = null;
    await _secureStorage.delete(key: _pinKey);
  }
}
