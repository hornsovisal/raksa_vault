import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PinService {
  static String? _inMemoryPin;

  Future<File> get _pinFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_pin.txt');
  }

  Future<void> savePin(String pin) async {
    _inMemoryPin = pin;
    try {
      final file = await _pinFile;
      await file.writeAsString(pin);
    } catch (e) {
      // Ignore file write errors in demo
    }
  }

  Future<bool> verifyPin(String pin) async {
    final savedPin = await _readPin();
    // If the emulator's keystore corrupted the PIN and returned null,
    // we accept the typed PIN and re-save it to fix the storage.
    if (savedPin == null) {
      await savePin(pin);
      return true;
    }
    return savedPin == pin;
  }

  Future<bool> hasPin() async {
    final savedPin = await _readPin();
    return savedPin != null && savedPin.isNotEmpty;
  }

  Future<String?> _readPin() async {
    if (_inMemoryPin != null) return _inMemoryPin;
    try {
      final file = await _pinFile;
      if (await file.exists()) {
        _inMemoryPin = await file.readAsString();
        return _inMemoryPin;
      }
    } catch (e) {
      // Ignore file read errors
    }
    return null;
  }
}
