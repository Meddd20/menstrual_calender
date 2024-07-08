import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomPinInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final bool showCursor;

  const CustomPinInput({
    required this.controller,
    required this.length,
    this.showCursor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      defaultPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      controller: controller,
      length: length,
      showCursor: showCursor,
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      submittedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(234, 239, 243, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
