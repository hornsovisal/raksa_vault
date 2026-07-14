import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raksa_vault/main.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    // Check password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));

      return;
    }

    // Check password strength
    if (!isStrongPassword(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must have 8 characters, uppercase, lowercase and number",
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create Firebase account
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Save full name in Firebase profile
      await userCredential.user?.updateDisplayName(
        _fullNameController.text.trim(),
      );

      final user = userCredential.user;

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VaultDashboardScreen(
              repository: vaultRepository,
              userId: user.uid,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Register failed")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              "Raksa Vault",
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
                "Create Account",
                style: AppTextStyles.headline.copyWith(fontSize: 24),

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                "Create your secure vault account.",

                style: TextStyle(fontSize: 14, color: AppColors.textBody),

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              CustomTextField(
                controller: _fullNameController,
                label: "Full Name",
                hint: "Preap Sovath",
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                label: "Email Address",
                hint: "name@example.com",
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                isPassword: true,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                hint: "••••••••",
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
                      "• At least 8 characters",
                      style: TextStyle(fontSize: 12, color: AppColors.textBody),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "• One uppercase letter",
                      style: TextStyle(fontSize: 12, color: AppColors.textBody),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "• One lowercase letter",
                      style: TextStyle(fontSize: 12, color: AppColors.textBody),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "• One number",
                      style: TextStyle(fontSize: 12, color: AppColors.textBody),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),

                        foregroundColor: Colors.white,
                      ),

                      onPressed: _register,

                      child: const Text("Create Account"),
                    ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.textBody, fontSize: 14),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),

                    child: const Text(
                      "Log In",

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
