import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class SetupSuccessScreen extends StatefulWidget {
  const SetupSuccessScreen({super.key});

  @override
  State<SetupSuccessScreen> createState() => _SetupSuccessScreenState();
}

class _SetupSuccessScreenState extends State<SetupSuccessScreen> {
  int _secondsLeft = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        _navigateToDashboard();
      }
    });
  }

  void _navigateToDashboard() {
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => route.isFirst,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Raksa Vault',
          style: AppTextStyles.headline.copyWith(
            fontSize: 20,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              
              // Success Icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF69F0AE), // Light green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 64,
                    color: Color(0xFF004D40), // Dark green
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Setup Successful',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline.copyWith(
                  fontSize: 24,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              const Text(
                'Your Raksa Vault is now secured with\nmilitary-grade protocols and biometric\nauthentication.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Info Cards
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.fingerprint,
                      title: 'Biometrics Active',
                      status: 'ENCRYPTED',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.security,
                      title: '256-bit AES',
                      status: 'STRICT',
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Continue Button
              CustomButton(
                text: 'Continue',
                backgroundColor: const Color(0xFF0D256C),
                onPressed: () {
                  _timer?.cancel();
                  _navigateToDashboard();
                },
              ),
              
              const SizedBox(height: 24),
              
              // Bottom Indicator Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C853), // Green dot
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Automated security scan starting in ${_secondsLeft}s...',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF), // Light blue background for icon
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E3A8A), // Dark blue icon
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00C853), // Green status text
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
