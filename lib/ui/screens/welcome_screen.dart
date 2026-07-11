import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
// import 'login_screen.dart';
// import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: AppColors.primary),

              const SizedBox(height: 20),

              const Text('Raksa Vault', style: AppTextStyles.headline),

              const SizedBox(height: 8),

              const Text(
                'Secure your sensitive data with PIN and biometric protection.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 32),

              // Go to Register Screen
              CustomButton(
                text: 'Create Account',
                onPressed: () {
                  // Navigation will be added later
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const RegisterScreen(),
                  //   ),
                  // );
                },
              ),

              const SizedBox(height: 12),

              // Go to Login Screen
              CustomButton(
                text: 'Login',
                outlined: true,
                onPressed: () {
                  // Navigation will be added later
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginScreen(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
