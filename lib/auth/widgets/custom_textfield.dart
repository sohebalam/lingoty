import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      required this.prefixIcon,
      this.obscureText = false,
      this.onPressed,
      this.suffixIcon});
  final String hintText;
  final TextEditingController textEditingController;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool? obscureText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: textEditingController,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onPressed,
          child: Icon(suffixIcon),
        ),
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        fillColor: Colors.white12,
        filled: true,
      ),
    );
  }
}
