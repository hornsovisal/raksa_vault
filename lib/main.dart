import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'ui/screens/welcome_screen.dart';

void main() async {
  // 1. Un-comment this so Flutter can set up native channels before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Un-comment and pass the currentPlatform options from firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const RaksaVaultApp());
}

class RaksaVaultApp extends StatelessWidget {
  const RaksaVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raksa Vault',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const WelcomeScreen(),
    );
  }
}
