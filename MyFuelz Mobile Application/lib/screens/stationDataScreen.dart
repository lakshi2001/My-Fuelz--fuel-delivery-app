import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/backbutton.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/common/phoneNumber_field.dart';
import 'package:myfuelz/components/common/text_feild.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/screens/role_selectedScreen.dart';
import 'package:myfuelz/screens/signup.dart';
import 'package:myfuelz/services/validate_service.dart';

import '../components/common/multiple_line_text_feild.dart';
import '../components/common/number_field.dart';
import '../globle/page_transition.dart';
import '../globle/staus/error.dart';
import '../layout/tanker/address.dart';

class StationDataScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String role;
  final Uint8List? image;
  const StationDataScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.role,
    required this.image,
  });

  @override
  State<StationDataScreen> createState() => _StationDataScreenState();
}

class _StationDataScreenState extends State<StationDataScreen> {
  final _stationNameController = TextEditingController();

  final _descController = TextEditingController();

  final _numOfFuelLitController = TextEditingController();

  final _validateService = ValidateService();

  final _formKey = GlobalKey<FormState>();
  String? fuelType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 30.0,
              ),
              child: BackButtonWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 40.0,
                left: relativeWidth * 30.0,
              ),
              child: const DefaultText(
                colorR: Color(0xFF22242E),
                content: 'Fill in your Fuel station details to get started',
                fontSizeR: 35,
                fontWeightR: FontWeight.w400,
                textAlignR: TextAlign.start,
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
                    'This data will be helping to reach more users with accurate and reliable',
                fontSizeR: 15,
                fontWeightR: FontWeight.w400,
                textAlignR: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 25.0,
                right: relativeWidth * 25.0,
              ),
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x23154378),
                      blurRadius: 50,
                      offset: Offset(12, 26),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: CustomTextField(
                  controller: _stationNameController,
                  hintText: 'Station Name',
                  validate: (value) => _validateService.isEmptyField(value!),
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 25.0,
                right: relativeWidth * 25.0,
              ),
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x23154378),
                      blurRadius: 50,
                      offset: Offset(12, 26),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: MultipleLineTextField(
                  controller: _descController,
                  hintText: 'Description',
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 30.0,
                right: relativeWidth * 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DefaultText(
                    colorR: Color(0xFF22242E),
                    content: 'Select Fuel Type',
                    fontSizeR: 15,
                    fontWeightR: FontWeight.w200,
                    textAlignR: TextAlign.start,
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Petrol',
                        groupValue: fuelType,
                        onChanged: (String? value) {
                          setState(() {
                            fuelType = value;
                          });
                        },
                      ),
                      const Text('Petrol'),
                      Radio<String>(
                        value: 'Diesel',
                        groupValue: fuelType,
                        onChanged: (String? value) {
                          setState(() {
                            fuelType = value;
                          });
                        },
                      ),
                      const Text('Diesel'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 20.0,
                left: relativeWidth * 25.0,
                right: relativeWidth * 25.0,
              ),
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x23154378),
                      blurRadius: 50,
                      offset: Offset(12, 26),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: NumberTextField(
                  controller: _numOfFuelLitController,
                  hintText: 'Number of Litters Have',
                  validate: (value) => _validateService.isEmptyField(value!),
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 120.0,
                left: relativeWidth * 120.0,
                right: relativeWidth * 120.0,
              ),
              child: Center(
                child: ButtonWidget(
                  onPressed: () {
                    final isValidForm = _formKey.currentState!.validate();

                    if (isValidForm && fuelType != null) {
                      Navigator.of(context).push(
                        createRoute(
                            // SignupScreen(

                            // ),
                            AddAddressPopup(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              phoneNum: widget.phoneNum,
                              role: widget.role,
                              image: widget.image,
                              stationName: _stationNameController.text,
                              fuelLit: _numOfFuelLitController.text,
                              desc: _descController.text.isNotEmpty
                                  ? _descController.text
                                  : '',
                            ),
                            TransitionType.rightToLeft),
                      );
                    } else {
                      fuelType == null
                          ? showErrorDialog(
                              context, 'Please select the fuel type')
                          : showErrorDialog(context, 'Please fill the field');
                    }
                  },
                  minHeight: relativeHeight * 75,
                  buttonName: 'Next',
                  tcolor: Colors.white,
                  bcolor: const Color(0xFF154478),
                  borderColor: Colors.white,
                  radius: 15,
                  fcolor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
