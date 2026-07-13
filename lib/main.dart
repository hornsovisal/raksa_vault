import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firebase_core/firebase_core.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: Builder(
            builder: (context) {
              return Container(
                color: Theme.of(
                  context,
                ).scaffoldBackgroundColor, // Replaced AppColors.background to use the material 3 theme
                child: MaxWidthBox(
                  maxWidth: 1200,
                  child: ResponsiveScaledBox(
                    width: ResponsiveValue<double?>(
                      context,
                      defaultValue: null,
                      conditionalValues: [
                        Condition.equals(name: MOBILE, value: 450),
                        Condition.between(start: 800, end: 1100, value: 800),
                        Condition.between(start: 1100, end: 9999, value: 1000),
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
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
      home: const WelcomeScreen(),
    );
  }
}
