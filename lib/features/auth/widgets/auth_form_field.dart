import 'package:flutter/material.dart';

class AuthFormField extends StatefulWidget {
  const AuthFormField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        keyboardType: widget.keyboardType,
        style: const TextStyle(color: Colors.white),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Заполните поле';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // Показываем иконку только если изначально obscureText = true
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              // Меняем иконку в зависимости от состояния
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white54,
            ),
            onPressed: _toggleObscure,
          )
              : null,
        ),
      ),
    );
  }
}
