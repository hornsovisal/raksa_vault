import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricService {
  // use device face authentication
  final LocalAuthentication auth = LocalAuthentication();

  // check if face authentication is enrolled
  Future<bool> hasFaceAuth() async {
    try {
      final biometrics = await auth.getAvailableBiometrics();

      return biometrics.contains(BiometricType.face);
    } on PlatformException {
      return false;
    }
  }

  // open face authentication prompt
  Future<bool> authenticateFace({
    String reason = 'Scan your face to unlock this record',
  }) async {
    try {
      final faceAvailable = await hasFaceAuth();

      // no face enrolled on device
      if (!faceAvailable) {
        return false;
      }

      return await auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          // dont allow device pin or password
          biometricOnly: true,

          // continue authentication after app background
          stickyAuth: true,

          // show system error dialog
          useErrorDialogs: true,
        ),
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Face Authentication',
            biometricHint: 'Scan your face',
            biometricNotRecognized: 'Face not recognized',
            biometricRequiredTitle: 'Face authentication required',
            cancelButton: 'Use Vault PIN',
          ),
          IOSAuthMessages(
            cancelButton: 'Use Vault PIN',
            lockOut: 'Face ID is locked. Unlock your iPhone and try again.',
          ),
        ],
      );
    } on PlatformException {
      return false;
    }
  }

  // close current face scan
  Future<void> stopAuthentication() async {
    try {
      await auth.stopAuthentication();
    } on PlatformException {
      // no action needed
    }
  }
}
