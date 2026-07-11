import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Logo Row
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.primary, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Raksa Vault',
                          style: AppTextStyles.headline.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Image Card
                    Container(
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
                      padding: const EdgeInsets.all(32),
                      child: Image.asset(
                        'assets/image_2026-06-30_14-08-59.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Welcome Text
                    Text(
                      'Welcome to Raksa Vault',
                      style: AppTextStyles.headline.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Secure your sensitive information with local encryption, biometric authentication, and offline storage.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBody,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    // Buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create Account'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 32),
                    // Footer
                    const Center(
                      child: Text(
                        '© 2026 Raksa Vault',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
