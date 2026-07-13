import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_textfield.dart';
import 'vault_dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Check password strength
  bool isStrongPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  // Check email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _register() async {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Full name validation
    if (name.isEmpty) {
      _showMessage('Please enter your full name');
      return;
    }

    // Email validation
    if (!isValidEmail(email)) {
      _showMessage('Please enter a valid email');
      return;
    }

    // Confirm password
    if (password != confirmPassword) {
      _showMessage("Passwords don't match");
      return;
    }

    // Strong password validation
    if (!isStrongPassword(password)) {
      _showMessage(
        'Password must contain 8+ characters, uppercase, lowercase, and number',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VaultDashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Registration failed');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Raksa Vault',
              style: AppTextStyles.headline.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline.copyWith(fontSize: 24),
              ),

              const SizedBox(height: 8),

              const Text(
                'Create your secure vault account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textBody),
              ),

              const SizedBox(height: 32),

              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'Preap Sovath',
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'name@example.com',
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                isPassword: true,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: '••••••••',
                isPassword: true,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• At least 8 characters'),
                    SizedBox(height: 4),
                    Text('• One uppercase letter'),
                    SizedBox(height: 4),
                    Text('• One lowercase letter'),
                    SizedBox(height: 4),
                    Text('• One number'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Create Account'),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.textBody),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              const Center(
                child: Text(
                  'SECURE BY DESIGN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
