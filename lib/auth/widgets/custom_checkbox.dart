import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox(
      {super.key, required this.value, required this.onChanged});
  final bool value;
  final void Function(bool? val) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            value: value,
            onChanged: onChanged),
        const Text("Remember me"),
      ],
    );
  }
}
