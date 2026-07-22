import 'package:flutter/material.dart';
import 'package:raksa_vault/data/services/pin_service.dart';
import 'package:raksa_vault/ui/theme/app_theme.dart';
import 'package:raksa_vault/ui/widgets/custom_button.dart';
import 'package:raksa_vault/ui/widgets/pin_pad.dart';
import 'package:raksa_vault/data/services/biometric_service.dart';

import '../../main.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => SetupPinScreenState();
}

class SetupPinScreenState extends State<SetupPinScreen> {
  String? errorMsg;
  String enteredPin = '';
  final pinService = PinService();
  final biometricService = BiometricService();
  bool isLoading = false;

  void handlePinChanged(String pin) {
    setState(() {
      enteredPin = pin;
      errorMsg = null;
    });
  }

  void handleFinishSetup() async {
    if (enteredPin.length != 6) return;
    setState(() {
      isLoading = true;
    });
    //Save the pin to Flutter secuer storage
    await pinService.savePin(enteredPin);
    //init the encrypt db with pin
    initializeEncryptedDatabase(enteredPin);
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        content: const Text(
          'PIN enabled successfully',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    // Check if device supports face scan
    final supportsFace = await biometricService.hasFaceAuth();
    if (supportsFace && mounted) {
      // Navigate to FaceScanScreen
      final result = await Navigator.pushNamed(context, '/face_scan');
      if (result == true) {
        // Face scanned successfully
      }
    }

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FE,
      ), // Background color matching the design
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Raksa Vault',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18,
            color: const Color(0xFF1E3A8A),
          ), // Dark blue
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Secure Your Vault',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 24,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose how you\'d like to protect your\nsensitive information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textBody, fontSize: 14),
                ),
                const SizedBox(height: 32),

                const SizedBox(height: 32),

                // Setup PIN Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Setup Security PIN',
                        style: AppTextStyles.headline.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A 6-digit PIN is required for fallback\naccess.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textBody,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PinPad(
                        pinLength: 6,
                        onPinEntered: (pin) {
                          handlePinChanged(pin);
                        },
                        onPinChanged: handlePinChanged,
                        errorText: errorMsg,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Finish Setup',
                        isLoading: isLoading,
                        backgroundColor: enteredPin.length == 6
                            ? const Color(0xFF1E3A8A)
                            : const Color(0xFFCBD5E1),
                        textColor: enteredPin.length == 6
                            ? Colors.white
                            : const Color(0xFF64748B),
                        onPressed: enteredPin.length == 6
                            ? handleFinishSetup
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
