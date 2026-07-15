import 'package:firebase_auth/firebase_auth.dart';
import '../../models/app_user.dart';
import '../services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();
  // to sere curent user
  AppUser? get currentUser => _authService.currentUser;
  //to see is login or not , check if we have curerent user or not
  bool get isLoggedIn => currentUser != null;
  Stream<AppUser?> get authStateChanges => _authService.authStateChanges;

  //sign up repo and catche the error
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      return await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _authService.login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.logout();
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  // all error messaeg tto show
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
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
