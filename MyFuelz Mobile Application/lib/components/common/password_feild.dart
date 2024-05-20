import 'package:flutter/material.dart';
import '../../globle/constants.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validate;
  final void Function()? togglePasswordView;
  final bool isHidden;

  const CustomPasswordField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.validate,
      required this.togglePasswordView,
      required this.isHidden})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0x6022242E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: EdgeInsets.only(
            left: relativeWidth * 28,
            top: relativeHeight * 20,
            bottom: relativeHeight * 20),
        fillColor: const Color(0xFFFFFFFF),
        filled: true,
        suffixIcon: InkWell(
          onTap: togglePasswordView,
          child: Icon(
            Icons.visibility,
            color: isHidden == true ? Color(0xFFD7D7D7) : Color(0xFF154478),
          ),
        ),
      ),
      validator: validate,
    );
  }
}
