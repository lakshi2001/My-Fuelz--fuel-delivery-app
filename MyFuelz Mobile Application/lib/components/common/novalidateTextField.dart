import 'package:flutter/material.dart';
import '../../globle/constants.dart';

class NoValidateCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
 

  const NoValidateCustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0x6022242E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: EdgeInsets.only(
            left: relativeWidth * 28,
            top: relativeHeight * 25,
            bottom: relativeHeight * 25),
        fillColor: const Color(0xFFFFFFFF),
        filled: true,
      ),
      
    );
  }
}
