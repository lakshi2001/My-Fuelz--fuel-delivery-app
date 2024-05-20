import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../globle/constants.dart';

Future<void> showConnetionDialog(
    BuildContext context, bool isDeviceConnected, bool isAlertSet) async {
  Size size = MediaQuery.of(context).size;
  double relativeWidth = size.width / Constants.referenceWidth;
  double relativeHeight = size.height / Constants.referenceHeight;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return CupertinoAlertDialog(
          title: const Text('Oops!'),
          content: Column(
            children: [
              // Container(
              //   child: Lottie.asset('assets/wrong.json',
              //       animate: true,
              //       height: relativeHeight * 50,
              //       width: relativeWidth * 50),
              // ),
              const Text(
                  'No internet connection found. \n Check your connection.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');

                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;

                if (!isDeviceConnected) {
                  // ignore: use_build_context_synchronously
                  showConnetionDialog(
                    context,
                    isDeviceConnected,
                    isAlertSet,
                  );
                  setState(() {
                    isAlertSet = true;
                  });
                }
              },
              child: const Text('Okay'),
            ),
          ],
        );
      }),
    );
  });
}
