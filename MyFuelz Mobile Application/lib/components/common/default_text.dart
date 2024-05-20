import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DefaultText extends StatelessWidget {
  final String content;
  final double fontSizeR;
  final Color colorR;
  final TextAlign textAlignR;
  final FontWeight fontWeightR;

  const DefaultText({
    Key? key,
    required this.content,
    required this.fontSizeR,
    required this.colorR,
    required this.textAlignR,
    required this.fontWeightR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: fontSizeR,
        fontWeight: fontWeightR,
        color: colorR,
      ),
      textAlign: textAlignR,
    );
  }
}
