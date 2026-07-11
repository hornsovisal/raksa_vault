import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; /

class CustomButton extends StatelessWidget {
  final String text; // button name
  final VoidCallback onPressed; // function when button is clicked
  final bool outlined; 
  final Color? backgroundColor; // custom background color
  final Color? textColor; // custom text color

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // if outlined is true, show outline button
    if (outlined) {
      return SizedBox(
        width: double.infinity, // make button full width
        height: 48, // button height
        child: OutlinedButton(
          onPressed: onPressed, // run function
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.primary,
            side: const BorderSide(
              color: AppColors.border, // button border color
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // round corner
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: textColor ?? AppColors.primary,
            ),
          ),
        ),
      );
    }

    // if outlined is false, show normal button
    return SizedBox(
      width: double.infinity, // full width button
      height: 48, // button height
      child: ElevatedButton(
        onPressed: onPressed, // button click action
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0, // remove shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // make corner round
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
