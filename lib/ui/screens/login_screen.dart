import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepository = AuthRepository();

  //two text field email password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome Back',
              style: AppTextStyles.headline.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to access your secure vault.',
              style: TextStyle(fontSize: 14, color: AppColors.textBody),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // White Form Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'name@company.com',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    isPassword: true,
                    trailing: GestureDetector(
                      onTap: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Login',
                    isLoading: _isLoading,
                    onPressed:
                        (_emailController.text.trim().isEmpty ||
                            _passwordController.text.isEmpty)
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              // Call the repository to signin with email
                              await _authRepository.signInWithEmail(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );

                              if (!context.mounted) return;
                              Navigator.pushNamed(context, '/unlock');
                            } catch (e) {
                              if (!context.mounted) return;

                              // Extract message, stripping out the "Exception: " prefix
                              final errorMessage = e.toString().replaceAll(
                                'Exception: ',
                                '',
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: AppColors.textBody, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    //go to register
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text(
                    'Create Account',
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
    );
  }
}
