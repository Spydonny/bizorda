import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    super.key,
    this.onPressed,
    this.text = 'Создать',
  });

  final String text;
  final void Function()? onPressed;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isDisabled = false;

  Future<void> _handlePress() async {
    if (_isDisabled || widget.onPressed == null) return;
    setState(() => _isDisabled = true);

    try {
      widget.onPressed!();
    } catch (e) {
      // при ошибке включаем кнопку снова
      setState(() => _isDisabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: _isDisabled ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
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
          widget.text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
