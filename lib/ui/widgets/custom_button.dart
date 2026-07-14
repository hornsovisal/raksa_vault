import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  // These are the properties our custom button can accept.
  // Making a reusable widget like this keeps our code clean and our UI consistent across the app.
  final String text;
  final VoidCallback? onPressed; // Nullable so the button can be disabled
  final bool outlined; // Switches between an ElevatedButton and OutlinedButton
  final bool isLoading; // Shows a loading spinner when true
  final IconData? icon; // Optional icon to display next to the text
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Outlined Button
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.primary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _buildChild(textColor ?? AppColors.primary),
        ),
      );
    }

    // Filled Button
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(textColor ?? Colors.white),
      ),
    );
  }

  Widget _buildChild(Color progressColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: AppTextStyles.button.copyWith(color: progressColor),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: progressColor),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.button.copyWith(color: progressColor),
    );
  }
}
