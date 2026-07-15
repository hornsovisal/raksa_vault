import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  // Use Flutter Secure Storage which use Android Keystore and iOS Keychain
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Verifies if the entered PIN matches the securely stored PIN
  Future<bool> verifyPin(String pin) async {
    final savedPin = await _readPin();

    // If the PIN is missing, the user must go through setup  registration.
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

  /// Reads the PIN securely from Flutter secure storage
  Future<String?> _readPin() async {
    if (_inMemoryPin != null) return _inMemoryPin;
    try {
      _inMemoryPin = await _secureStorage.read(key: _pinKey);
      return _inMemoryPin;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Clear the PIN if the user close app
  Future<void> clearPin() async {
    _inMemoryPin = null;
    await _secureStorage.delete(key: _pinKey);
  }

  //get pin for biometric
  Future<String?> getPinForBiometric() async {
    return await _readPin();
  }
}
