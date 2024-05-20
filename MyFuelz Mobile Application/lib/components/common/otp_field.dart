import 'package:flutter/material.dart';
import '../../globle/constants.dart';

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validate;
  final FocusNode focusNode;
  final onchange;

  const OTPField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validate,
    required this.focusNode,
    required this.onchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 1,
      onChanged: onchange,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0x6022242E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: EdgeInsets.only(
            // left: relativeWidth * 20,
            top: relativeHeight * 20,
            bottom: relativeHeight * 20),
        fillColor: const Color(0xFFFFFFFF),
        filled: true,
        counterText: "",
      ),
      validator: validate,
    );
  }
}
