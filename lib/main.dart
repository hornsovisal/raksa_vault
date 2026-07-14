import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'firebase_options.dart';
import 'data/database/app_database.dart';
import 'data/repositories/vault_repository.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/theme/app_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'ui/screens/unlock_screen.dart';
import 'ui/screens/setup_pin_screen.dart';
import 'data/services/pin_service.dart';
import 'ui/screens/vault_dashboard_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/register_screen.dart';

// One database instance for the entire app
final AppDatabase database = AppDatabase();

// One repository instance for the entire app
final VaultRepository vaultRepository = VaultRepository(database);
final FirebaseAuthService _authService = FirebaseAuthService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: Builder(
            builder: (context) {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: MaxWidthBox(
                  maxWidth: 1200,
                  child: ResponsiveScaledBox(
                    width: ResponsiveValue<double?>(
                      context,
                      defaultValue: null,
                      conditionalValues: [
                        const Condition.equals(name: MOBILE, value: 450),
                        const Condition.between(
                          start: 800,
                          end: 1100,
                          value: 800,
                        ),
                        const Condition.between(
                          start: 1100,
                          end: 9999,
                          value: 1000,
                        ),
                      ],
                    ).value,
                    child: BouncingScrollWrapper.builder(
                      context,
                      child!,
                      dragWithMouse: true,
                    ),
                  ),
                ),
              );
            },
          ),
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
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
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<bool>(
            future: PinService().hasPin(),
            builder: (context, pinSnapshot) {
              if (pinSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final hasPin = pinSnapshot.data ?? false;
              if (hasPin) {
                return const UnlockScreen();
              } else {
                return const SetupPinScreen();
              }
            },
          );
        }
        return const WelcomeScreen();
      },
    );
  }
}
