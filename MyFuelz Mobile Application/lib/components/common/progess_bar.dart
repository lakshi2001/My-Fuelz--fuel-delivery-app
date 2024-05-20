import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../globle/constants.dart';

class CommonProgressBar extends StatelessWidget {
  final double percentage;

  const CommonProgressBar({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    return Center(
      child: LinearPercentIndicator(
        width: relativeWidth * 190,
        animation: true,
        lineHeight: 10.0,
        animationDuration: 2000,
        percent: percentage,
        animateFromLastPercent: true,
        // center: const Text("10.0%"),
        barRadius: const Radius.circular(10),
        backgroundColor: const Color.fromRGBO(205, 210, 209, 1),
        progressColor: const Color.fromRGBO(52, 165, 103, 1),
      ),
    );
  }
}
