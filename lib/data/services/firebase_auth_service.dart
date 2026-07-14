import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';

class FirebaseAuthService {
  //firebase auth is in service which auto create by firebase console
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  //to seethe current user login  now
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return _convertUser(user);
  }

  //covert from firebase to our object app user
  AppUser _convertUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  //to see for auth state changes (login or logout).
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return _convertUser(user);
    });
  }

  //function to register user with email and password
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

      //after success create convert it to our object
      return _convertUser(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  //function to login user with firebase
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      //login with firebase auth
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Login failed. User not found.');
      }

      //after success create convert it to our object
      return _convertUser(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //any error message customized
  String _getErrorMessage(FirebaseAuthException e) {
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
      // Kept for older Firebase versions fallback
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
