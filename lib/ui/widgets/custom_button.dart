import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // These are the properties our custom button can accept.
  // Making a reusable widget like this keeps our code clean and our UI consistent across the app.
  final String text;
  final VoidCallback? onPressed; // Nullable so the button can be disabled
  final bool isLoading; // Shows a loading spinner when true
  final bool isOutlined; // Switches between an ElevatedButton and OutlinedButton
  final IconData? icon; // Optional icon to display next to the text

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              child: _buildChild(),
            )
          : ElevatedButton(
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 20),
        ],
      );
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
