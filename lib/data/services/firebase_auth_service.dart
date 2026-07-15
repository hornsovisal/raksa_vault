import 'package:firebase_auth/firebase_auth.dart';
import '../../models/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  //to check our curren user
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _convertUser(user);
  }

  //convert it to objects with uid , email , name
  AppUser _convertUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return _convertUser(user);
    });
  }

  //to register
  Future<AppUser> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    //call firebase auth sdk to create suer
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Registration failed. User not found.');

    return _convertUser(user);
  }

  //login sercice
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('Login failed. User not found.');

    return _convertUser(user);
  }

  //to logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
