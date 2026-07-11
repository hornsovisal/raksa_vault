import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    });
  }

  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Registration failed. User not found.');
      }

      return AppUser(
        uid: user.uid,
        email: user.email ?? email,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Login failed. User not found.');
      }

      return AppUser(
        uid: user.uid,
        email: user.email ?? email,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
