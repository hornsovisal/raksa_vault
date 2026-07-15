import 'package:flutter/material.dart';
import 'face_scan_screen.dart';
import '../widgets/pin_pad.dart';
import '../theme/app_theme.dart';
import '../../data/services/pin_service.dart';

import '../widgets/custom_button.dart';

import '../../main.dart';

class UnlockScreen extends StatefulWidget {
  const UnlockScreen({super.key});

  @override
  State<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  String? _errorMsg;
  final _pinService = PinService();
  bool _hasAttemptedAutoBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasAttemptedAutoBiometric) {
        _hasAttemptedAutoBiometric = true;
        _attemptBiometricUnlock();
      }
    });
  }

  Future<void> _attemptBiometricUnlock() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FaceScanScreen()),
    );
    
    if (result == true) {
      final pin = await _pinService.getPinForBiometric();
      if (!mounted) return;
      if (pin != null) {
        initializeEncryptedDatabase(pin);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => route.isFirst,
        );
      } else {
        setState(() {
          _errorMsg = 'Failed to retrieve PIN for biometrics.';
        });
      }
    }
  }

  void _handlePinEntered(String pin) async {
    final isValid = await _pinService.verifyPin(pin);
    if (isValid) {
      if (!mounted) return;
      setState(() {
        _errorMsg = null;
      });

      //init our db with pin , no pin = cannot access
      initializeEncryptedDatabase(pin);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => route.isFirst,
      );
    } else {
      if (!mounted) return;
      setState(() {
        _errorMsg = 'Incorrect PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                'Raksa Vault',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline.copyWith(
                  fontSize: 28,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure your sensitive information',
                style: TextStyle(color: AppColors.textBody, fontSize: 14),
              ),
              const SizedBox(height: 48),

              // Avatar Placeholder
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF), // very light blue
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Unlock with Biometrics',
                backgroundColor: const Color(0xFF1E3A8A), // dark blue
                onPressed: _attemptBiometricUnlock,
              ),
              const SizedBox(height: 12),

              const Text(
                'Use fingerprint or Face ID',
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 32),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 32),

              PinPad(
                pinLength: 6,
                onPinEntered: _handlePinEntered,
                errorText: _errorMsg,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
