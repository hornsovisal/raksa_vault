import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/theme/app_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'ui/screens/unlock_screen.dart';
import 'ui/screens/setup_pin_screen.dart';
import 'data/services/pin_service.dart';
import 'ui/screens/vault_dashboard_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/register_screen.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before calling async methods like Firebase initialization.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using the platform-specific options.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const RaksaVaultApp());
}

class RaksaVaultApp extends StatelessWidget {
  const RaksaVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raksa Vault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
      routes: {
        '/dashboard': (context) => const VaultDashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/unlock': (context) => const UnlockScreen(),
        '/setup_pin': (context) => const SetupPinScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // Check if they have a PIN set
          return FutureBuilder<bool>(
            future: PinService().hasPin(),
            builder: (context, pinSnapshot) {
              if (pinSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              final hasPin = pinSnapshot.data ?? false;
              if (hasPin) {
                return const UnlockScreen(); // Returning user with PIN
              } else {
                return const SetupPinScreen(); // Logged in but missing PIN
              }
            },
          );
        }
        
        // User is not logged in
        return const WelcomeScreen();
      },
    );
  }
}
