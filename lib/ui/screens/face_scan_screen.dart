import 'package:flutter/material.dart';

import '../../data/services/biometric_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() {
    return FaceScanScreenState();
  }
}

class FaceScanScreenState extends State<FaceScanScreen> {
  // face authentication service
  final BiometricService biometricService = BiometricService();

  // true while system face prompt is open
  bool isAuthenticating = false;

  // false when device does not have face authentication
  bool faceAvailable = true;

  // show authentication error
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    // start face scan after screen finish opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkFaceAndStart();
    });
  }

  // check if face authentication is available
  Future<void> checkFaceAndStart() async {
    final available = await biometricService.hasFaceAuth();

    if (!mounted) {
      return;
    }

    setState(() {
      faceAvailable = available;
    });

    if (!available) {
      setState(() {
        errorMessage =
            'Face authentication is not available or not configured.';
      });

      return;
    }

    await startFaceScan();
  }

  // open device face authentication prompt
  Future<void> startFaceScan() async {
    if (isAuthenticating) {
      return;
    }

    setState(() {
      isAuthenticating = true;
      errorMessage = null;
    });

    // this match your BiometricService method
    final success = await biometricService.authenticateFace(
      reason: 'Scan your face to unlock Raksa Vault',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isAuthenticating = false;
    });

    if (success) {
      // return true to previous screen
      Navigator.pop(context, true);
    } else {
      setState(() {
        errorMessage = 'Face authentication failed or was cancelled.';
      });
    }
  }

  @override
  void dispose() {
    // close face prompt when screen close
    biometricService.stopAuthentication();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Raksa Vault',
          style: AppTextStyles.headline.copyWith(
            fontSize: 20,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              Text(
                isAuthenticating
                    ? 'Scanning Face...'
                    : faceAvailable
                    ? 'Face Verification'
                    : 'Face Authentication Unavailable',
                textAlign: TextAlign.center,
                style: AppTextStyles.headline.copyWith(
                  fontSize: 28,
                  color: const Color(0xFF1E3A8A),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                faceAvailable
                    ? 'Look at your device to verify your identity.'
                    : 'Set up secure face authentication in your device settings.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textBody, fontSize: 14),
              ),

              const Spacer(),

              // face scanner design
              Center(
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(
                            0xFF1E3A8A,
                          ).withValues(alpha: 0.04),
                          border: Border.all(
                            color: const Color(
                              0xFF1E3A8A,
                            ).withValues(alpha: 0.15),
                          ),
                        ),
                        child: Icon(
                          faceAvailable
                              ? Icons.face_retouching_natural
                              : Icons.no_accounts_outlined,
                          size: 110,
                          color: const Color(
                            0xFF1E3A8A,
                          ).withValues(alpha: 0.45),
                        ),
                      ),

                      Positioned(
                        top: 0,
                        left: 0,
                        child: buildCorner(isTop: true, isLeft: true),
                      ),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: buildCorner(isTop: true, isLeft: false),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: buildCorner(isTop: false, isLeft: true),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: buildCorner(isTop: false, isLeft: false),
                      ),

                      // loading circle while face prompt is open
                      if (isAuthenticating)
                        const SizedBox(
                          width: 265,
                          height: 265,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // show error message
              if (errorMessage != null) ...[
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),
              ],

              // scan face button
              CustomButton(
                text: isAuthenticating
                    ? 'SCANNING FACE'
                    : faceAvailable
                    ? 'SCAN FACE AGAIN'
                    : 'CHECK FACE AGAIN',
                icon: Icons.face_retouching_natural,
                backgroundColor: const Color(0xFF1E3A8A),
                isLoading: isAuthenticating,
                onPressed: faceAvailable ? startFaceScan : checkFaceAndStart,
              ),

              const SizedBox(height: 16),

              // go back and use vault pin
              CustomButton(
                text: 'Use PIN Instead',
                isOutlined: true,
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // make one scanner corner
  Widget buildCorner({required bool isTop, required bool isLeft}) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: ScannerCornerPainter(
          isTop: isTop,
          isLeft: isLeft,
          color: const Color(0xFF1E3A8A),
          strokeWidth: 4,
          radius: 12,
        ),
      ),
    );
  }
}

class ScannerCornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final Color color;
  final double strokeWidth;
  final double radius;

  ScannerCornerPainter({
    required this.isTop,
    required this.isLeft,
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - radius);
      path.quadraticBezierTo(0, size.height, radius, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      );
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ScannerCornerPainter oldDelegate) {
    return oldDelegate.isTop != isTop ||
        oldDelegate.isLeft != isLeft ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
