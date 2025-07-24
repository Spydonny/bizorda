import 'package:flutter/material.dart';

class ButtonLocal extends StatelessWidget {
  const ButtonLocal({super.key, required this.label, required this.iconData, this.onPressed});
  final String label;
  final IconData iconData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(iconData, color: Colors.grey),
      label: Text( label,
        style: TextStyle(color: Colors.grey),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.black,
      ),
    );
  }
}
