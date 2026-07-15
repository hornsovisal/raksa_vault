import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricService {
  //local auth from library to do biometric auth
  final _auth = LocalAuthentication();

  /// Checks if Face ID is set up on the device
  Future<bool> hasFaceAuth() async {
    try {
      final hasBio = await _auth.canCheckBiometrics;
      if (!hasBio) return false;

      final enrolled = await _auth.getAvailableBiometrics();
      //return if it can face or not
      return enrolled.contains(BiometricType.face);
    } on PlatformException {
      return false;
    }
  }

  /// cal the face authentication prompt
  Future<bool> authenticate({required String reason}) async {
    try {
      final isReady = await hasFaceAuth();
      if (!isReady) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
        authMessages: const [
          //android message
          AndroidAuthMessages(
            signInTitle: 'Face Authentication Required',
            cancelButton: 'Use PIN',
          ),
          //ios message
          IOSAuthMessages(cancelButton: 'Use PIN'),
        ],
      );
    } on PlatformException {
      return false;
    }
  }
}
