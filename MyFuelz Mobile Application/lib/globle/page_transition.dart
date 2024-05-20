import 'package:flutter/material.dart';

enum TransitionType { downToUp, leftToRight, rightToLeft, upToDown }

Route createRoute(Widget page, TransitionType transitionType) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      switch (transitionType) {
        case TransitionType.downToUp:
          begin = Offset(0.0, 1.0);
          break;
        case TransitionType.upToDown:
          begin = Offset(1.0, 0.0);
          break;
        case TransitionType.leftToRight:
          begin = Offset(-1.0, 0.0);
          break;
        case TransitionType.rightToLeft:
          begin = Offset(1.0, 0.0);
          break;
        // Add more cases as needed
        default:
          begin = Offset.zero;
      }
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
