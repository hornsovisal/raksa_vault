import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return _convertUser(user);
  }

  AppUser _convertUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return _convertUser(user);
    });
  }

  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Registration failed. User not found.');
      }

      return _convertUser(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorMessage(e));
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Login failed. User not found.');
      }

      return _convertUser(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
