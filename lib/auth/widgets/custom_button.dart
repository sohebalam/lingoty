import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.width});
  final String buttonText;
  final VoidCallback onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlue, Colors.blue.withOpacity(0.5)],
          ),
        ),
        child: Center(
            child: Text(
          buttonText,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
