import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/globle/constants.dart';

class ElementCard extends StatelessWidget {
  final String name;
  final String time;
  final String imageurl;
  const ElementCard(
      {Key? key,
      required this.name,
      required this.time,
      required this.imageurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    return Container(
      width: relativeWidth * 180,
      height: relativeHeight * 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Card(
        color: Colors.white,
        elevation: 2, // Add elevation for a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: relativeHeight * 20),
                child: Image.asset(
                  imageurl,
                  fit: BoxFit.cover,
                  width: relativeWidth*80,
                  height: relativeHeight*80,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: DefaultText(
                      content: name,
                      fontSizeR: 15,
                      colorR: Color(0xFF000000),
                      textAlignR: TextAlign.center,
                      fontWeightR: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: relativeHeight * 5,
                  ),
                  Center(
                    child: DefaultText(
                      content: time,
                      fontSizeR: 15,
                      colorR: Color(0xFF000000),
                      textAlignR: TextAlign.center,
                      fontWeightR: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
