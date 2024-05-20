import 'package:flutter/material.dart';
import 'package:myfuelz/globle/constants.dart';

class ImageButton extends StatelessWidget {
  final String imagePath;
  final Color bcolor;
  final Color fcolor;
  final Color tcolor;
  final double radius;
  final double minHeight;
  final Color borderColor;
  final void Function()? onPressed;

  const ImageButton({
    Key? key, // Use 'Key?' instead of 'super.key'
    required this.imagePath,
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
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return TextButton(
      // style: ButtonStyle(
      //   // backgroundColor: MaterialStateProperty.all(bcolor),
      //   // shape: MaterialStateProperty.all(
      //   //   RoundedRectangleBorder(
      //   //     borderRadius: BorderRadius.all(Radius.circular(radius)),
      //   //   ),
      //   // ),
      //   // minimumSize:
      //   //     MaterialStateProperty.all(Size(double.infinity, minHeight)),
      //   // padding: MaterialStateProperty.all(
      //   //    EdgeInsets.symmetric(
      //   //     horizontal: relativeWidth* 8.0, // Adjust horizontal padding as needed
      //   //     vertical: relativeHeight* 8.0, // Adjust vertical padding as needed
      //   //   ),
      //   // ),
      // ),
      onPressed: () {
        onPressed!();
      },
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(20.0),
        child: Image(
          image: AssetImage(imagePath),
          height: relativeHeight * 60,
          width: relativeWidth * 60,
        ),
      ),
    );
  }
}
