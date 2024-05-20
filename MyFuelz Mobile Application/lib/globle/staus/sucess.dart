import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/page_transition.dart';
import 'package:myfuelz/screens/login.dart';

Future<void> showSuccessDialog(
  BuildContext context,
  String content,
  String buttonT,
  Future Function() param3,
) async {
  Size size = MediaQuery.of(context).size;
  double relativeWidth = size.width / Constants.referenceWidth;
  double relativeHeight = size.height / Constants.referenceHeight;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Success'),
        content: Column(
          children: [
            const SizedBox(
              width: 10,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(content),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: param3,
            child: Text(buttonT),
          ),
        ],
      ),
    );
  });
}
