import 'package:flutter/material.dart';

class TransparentTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final String? suffixText;
  final TextAlign? textAlign;
  final double? fontSize;

  const TransparentTextField({
    super.key,
    this.controller, this.hintText, this.keyboardType, this.maxLines,
    this.minLines, this.textInputAction, this.contentPadding, this.suffixText, this.textAlign, this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(color: Colors.white, fontSize: fontSize ?? 10), // текст белый
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70), // подсказка чуть менее яркая
        suffixText: suffixText,

        filled: true,
        fillColor: Colors.transparent, // фон полностью прозрачный
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      cursorColor: Colors.white,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,

    );
  }
}

