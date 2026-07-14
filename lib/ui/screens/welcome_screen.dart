import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Row(
                children: [
                  Image.asset(
                    'assets/images/reaksa-logo.png',
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Raksa Vault',
                    style: AppTextStyles.headline.copyWith(fontSize: 20),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Illustration Card
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/image_2026-06-30_14-08-59.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 48),

              // Title
              Text(
                'Welcome to Raksa Vault',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline.copyWith(fontSize: 24),
              ),

              const SizedBox(height: 16),

              const Text(
                'Secure your sensitive information with local encryption, biometric authentication, and offline storage.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textBody,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),
              // Create Account Button
              CustomButton(
                text: 'Create Account',
                onPressed: () => _goToRegister(context),
              ),

              const SizedBox(height: 16),
              CustomButton(
                text: 'Login',
                outlined: true,
                onPressed: () => _goToLogin(context),
              ),
              const SizedBox(height: 32),
              // Footer
              const Center(
                child: Text(
                  '© 2026 Raksa Vault',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
