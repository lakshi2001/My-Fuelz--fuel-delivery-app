import 'dart:io';

class Constants {
  static const referenceHeight = 932;
  static const referenceWidth = 430;
  String currentPlatfrom = Platform.isAndroid
      ? "android"
      : Platform.isIOS
          ? "iOS"
          : "other";
}
