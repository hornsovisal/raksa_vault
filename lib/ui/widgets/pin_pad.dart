import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Handles PIN dot indicators, error messages, and a numeric keypad.
class PinPad extends StatefulWidget {
  final int pinLength;
  final Function(String) onPinEntered;
  final String? errorText;

  const PinPad({
    super.key,
    this.pinLength = 6,
    required this.onPinEntered,
    this.errorText,
  });

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _pin = '';

  // Appends a number to the PIN string if not at max length
  void _onNumberPressed(String number) {
    if (_pin.length < widget.pinLength) {
      setState(() {
        _pin += number;
      });
      // Trigger callback once the PIN reaches the required length
      if (_pin.length == widget.pinLength) {
        widget.onPinEntered(_pin);
      }
    }
  }

  // Removes the last number from the PIN string
  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PIN dots indicator section
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.pinLength,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Color dots based on whether they have been filled
                color: index < _pin.length
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Wrong PIN error UI section
        SizedBox(
          height: 24, // Fixed height to prevent layout shift
          child: widget.errorText != null
              ? Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: AppColors.error, 
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        
        // Number buttons pad section
        _buildNumberPad(),
      ],
    );
  }

  // Builds the grid of number buttons (0-9) and the delete button
    Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNumberButton('1'),
              _buildNumberButton('3'),
              _buildNumberButton('2'),
            ],
          ),
          const SizedBox(height: 16),
          // ... (Rows for 4-5-6 and 7-8-9) ...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 64, height: 64),
              // Empty space for alignment
              _buildNumberButton('0'),
              _buildDeleteButton(),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable number button widget
  Widget _buildNumberButton(String number) {
    return TextButton(
      onPressed: () => _onNumberPressed(number),
      style: TextButton.styleFrom(
        shape: const CircleBorder(),
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.background,
      ),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 28, 
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // Special delete button widget
  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: _onDeletePressed,
      icon: const Icon(Icons.backspace_outlined, size: 28),
      color: AppColors.textDark,
    );
  }
}
