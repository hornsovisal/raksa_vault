import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/theme/app_theme.dart';

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
    // The MaterialApp is the root of our application.
    // We simplified this by removing complex responsive wrappers to keep the architecture beginner-friendly.
    return MaterialApp(
      title: 'Raksa Vault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}

