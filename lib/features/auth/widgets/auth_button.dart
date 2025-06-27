import 'package:flutter/material.dart';
import '../../../theme.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.title, this.onSubmit});
  final String title;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onSubmit,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.buttonGradient,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

