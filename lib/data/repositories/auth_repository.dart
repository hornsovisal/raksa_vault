// import '../../models/app_user.dart';
// import '../services/firebase_auth_service.dart';

/// The Authentication Repository manages user session operations.
class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository({FirebaseAuthService? authService})
    : _authService = authService ?? FirebaseAuthService();

  // Get the current logged-in user
  AppUser? get currentUser => _authService.currentUser;

  // to see to login/logout changes
  Stream<AppUser?> get authStateChanges => _authService.authStateChanges;

  // Handle Registration Request
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _authService.register(email: email, password: password);
  }

  // Handle Login  requests
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email: email, password: password);
  }

  // Handle Log out requests
  Future<void> signOut() async {
    await _authService.logout();
  }
}
