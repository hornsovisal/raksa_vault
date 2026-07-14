import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'user_secure_pin';

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<bool> verifyPin(String pin) async {
    final savedPin = await _storage.read(key: _pinKey);
    return savedPin == pin;
  }

  Future<bool> hasPin() async {
    final savedPin = await _storage.read(key: _pinKey);
    return savedPin != null && savedPin.isNotEmpty;
  }
}
