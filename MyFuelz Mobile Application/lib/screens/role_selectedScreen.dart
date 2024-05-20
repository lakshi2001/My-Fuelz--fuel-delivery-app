import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/backbutton.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/role/roleButton.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/page_transition.dart';
import 'package:myfuelz/screens/userBiodataScreen.dart';

import '../globle/page_transition.dart';

class RoleSelectedScreen extends StatelessWidget {
  const RoleSelectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return SafeArea(
        child: Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 30.0,
              ),
              child: const BackButtonWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 40.0,
                left: relativeWidth * 30.0,
              ),
              child: const DefaultText(
                colorR: Color(0xFF22242E),
                content: 'Continue with role',
                fontSizeR: 35,
                fontWeightR: FontWeight.w400,
                textAlignR: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 40.0,
                left: relativeWidth * 30.0,
              ),
              child: const DefaultText(
                colorR: Color(0xFF22242E),
                content:
                    'This data will be displayed in your account profile for security',
                fontSizeR: 15,
                fontWeightR: FontWeight.w400,
                textAlignR: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 50.0,
                right: relativeWidth * 50.0,
              ),
              child: Center(
                child: RoleButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      createRoute(
                          const UserBioDataScreen(
                            role: 'Tanker',
                          ),
                          TransitionType.rightToLeft),
                    );
                  },
                  minHeight: relativeHeight * 75,
                  buttonName: 'Tanker',
                  tcolor: const Color(0xFF22242E),
                  bcolor: Colors.white,
                  borderColor: Colors.white,
                  radius: 15,
                  fcolor: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 50.0,
                right: relativeWidth * 50.0,
              ),
              child: Center(
                child: RoleButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      createRoute(
                          const UserBioDataScreen(
                            role: 'User',
                          ),
                          TransitionType.rightToLeft),
                    );
                  },
                  minHeight: relativeHeight * 75,
                  buttonName: 'User',
                  tcolor: const Color(0xFF22242E),
                  bcolor: Colors.white,
                  borderColor: Colors.white,
                  radius: 15,
                  fcolor: Colors.grey,
                ),
              ),
            ),
          ]),
    ));
  }
}
