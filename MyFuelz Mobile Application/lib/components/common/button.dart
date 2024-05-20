import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonName;
  final Color bcolor;
  final Color fcolor;
  final Color tcolor;
  final double radius;
  final double minHeight;
  final Color borderColor;
  final void Function()? onPressed;

  const ButtonWidget({
    Key? key, // Use 'Key?' instead of 'super.key'
    required this.buttonName,
    required this.bcolor,
    required this.tcolor,
    required this.radius,
    required this.fcolor,
    required this.minHeight,
    required this.borderColor,
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bcolor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
        ),
       minimumSize: MaterialStateProperty.all(Size(double.infinity, minHeight)),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 20.0, // Adjust horizontal padding as needed
            vertical: 8.0, // Adjust vertical padding as needed
          ),
        ),
      ),
      onPressed: () {
        onPressed!();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            buttonName,
            style: TextStyle(
              color: tcolor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
