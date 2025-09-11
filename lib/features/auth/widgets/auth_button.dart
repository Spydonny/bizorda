import 'package:flutter/material.dart';
import '../../../theme.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({
    super.key,
    required this.title,
    required this.onSubmit,
  });

  final String title;
  final Future<void> Function() onSubmit;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _isDisabled = false;

  Future<void> _handlePress() async {
    if (_isDisabled) return;
    setState(() => _isDisabled = true);

    try {
      await widget.onSubmit();
    } catch (e) {
      // если хочешь, можно снова включать кнопку при ошибке
      setState(() => _isDisabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _isDisabled
        ? [Colors.grey.shade700, Colors.grey.shade800] // тёмный градиент
        : AppColors.buttonGradient;

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
        onPressed: _isDisabled ? null : _handlePress,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isDisabled
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
