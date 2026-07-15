import 'package:flutter/material.dart';

// Update this import path to match your actual structure
import '../../data/repositories/auth_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Initialize the repository
  final AuthRepository _authRepository = AuthRepository();

  bool isStrongPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _fullNameController.addListener(() => setState(() {}));
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
            Image.asset('assets/images/reaksa-logo.png', width: 24, height: 24),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                style: AppTextStyles.headline.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your secure vault account.',
                style: TextStyle(fontSize: 14, color: AppColors.textBody),
                textAlign: TextAlign.center,
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
                    Text(
                      '• At least 8 characters',
                      style: TextStyle(color: AppColors.textBody, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• One uppercase letter',
                      style: TextStyle(color: AppColors.textBody, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• One lowercase letter',
                      style: TextStyle(color: AppColors.textBody, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• One number',
                      style: TextStyle(color: AppColors.textBody, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Create Account',
                isLoading: _isLoading,
                onPressed:
                    !isStrongPassword(_passwordController.text) ||
                        _emailController.text.trim().isEmpty ||
                        _fullNameController.text.trim().isEmpty
                    ? null
                    : () async {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords don't match"),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          //call auth repo to signup with email , password , and pass name
                          await _authRepository.signUpWithEmail(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                            fullName: _fullNameController.text.trim(),
                          );

                          if (!context.mounted) return;
                          Navigator.pushNamed(context, '/setup_pin');
                        } catch (e) {
                          if (!context.mounted) return;

                          final errorMessage = e.toString().replaceAll(
                            'Exception: ',
                            '',
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(errorMessage)));
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.textBody, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
