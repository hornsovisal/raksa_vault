import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // Properties for the reusable custom button.
  final String text;
  final VoidCallback? onPressed; 
  final bool isLoading; 
  final bool isOutlined; 
  final IconData? icon; 
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
              ),
              onPressed: isLoading ? null : onPressed,
              child: _buildChild(),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
              ),
              onPressed: isLoading ? null : onPressed,
              child: _buildChild(),
            ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const CircularProgressIndicator.adaptive();
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: textColor),
        ],
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
