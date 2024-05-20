import 'package:flutter/material.dart';
import 'package:myfuelz/globle/constants.dart';


class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeHeight = size.height / Constants.referenceHeight;
    return Padding(
        padding: EdgeInsets.only(
          //left: relativeWidth * 10,
          top: relativeHeight * 5,
          //right: relativeWidth * 10
        ),
        child: const Divider(
          color: Color.fromRGBO(217, 217, 217, 1),
          thickness: 1.5, //thickness of divier line
          indent: 0,
          endIndent: 0, //spacing at the end of divider
        ));
  }
}
