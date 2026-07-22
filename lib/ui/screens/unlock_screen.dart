import 'package:flutter/material.dart';
import '../widgets/pin_pad.dart';
import '../theme/app_theme.dart';
import '../../data/services/biometric_service.dart';
import '../../data/services/pin_service.dart';
import '../../main.dart';

/// The main Unlock Screen for the application.
/// Shows a polished layout with the PinPad for user authentication.
class UnlockScreen extends StatefulWidget {
  const UnlockScreen({super.key});

  @override
  State<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  String? _errorMsg;
  final _biometricService = BiometricService();
  final _pinService = PinService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryFaceUnlock();
    });
  }

  Future<void> _tryFaceUnlock() async {
    final supportsFace = await _biometricService.hasFaceAuth();
    if (supportsFace && mounted) {
      final success = await _biometricService.authenticate(
        reason: 'Please authenticate to unlock Raksa Vault',
      );
      if (success && mounted) {
        final savedPin = await _pinService.getPinForBiometric();
        if (savedPin != null) {
          initializeEncryptedDatabase(savedPin);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        } else {
          setState(() {
            _errorMsg = 'Could not retrieve PIN for face unlock. Please enter PIN.';
          });
        }
      }
    }
  }

  // Handles logic when the full PIN is entered
  Future<void> _handlePinEntered(String pin) async {
    final isCorrect = await _pinService.verifyPin(pin);
    if (isCorrect) {
      if (!mounted) return;
      setState(() {
        _errorMsg = null;
      });
      initializeEncryptedDatabase(pin);

      // Navigate to the Dashboard upon successful unlock
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      if (!mounted) return;
      // Show an error if the PIN is incorrect
      setState(() {
        _errorMsg = 'Incorrect PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 48.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padlock icon representing security
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/reaksa-logo.png',
                        width: 64,
                        height: 64,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title text
                    Text(
                      'Welcome to Raksa Vault',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline.copyWith(fontSize: 28),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle text
                    const Text(
                      'Enter your 6-digit PIN to continue',
                      style: TextStyle(color: AppColors.textBody, fontSize: 16),
                    ),

                    const Spacer(),

                    // The custom PinPad widget
                    PinPad(
                      pinLength: 6,
                      onPinEntered: _handlePinEntered,
                      errorText: _errorMsg,
                    ),

                    const Spacer(),
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
