import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/backbutton.dart';

import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/layout/tanker/dropdown/dropdownstate.dart';

import '../../components/common/number_field.dart';
import '../../components/common/text_feild.dart';
import '../../globle/page_transition.dart';
import '../../globle/staus/error.dart';
import '../../screens/signup.dart';
import '../../services/validate_service.dart';

class AddAddressPopup extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String role;
  final String fuelLit;
  final String stationName;
  final String desc;
  final Uint8List? image;

  const AddAddressPopup({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.role,
    required this.stationName,
    required this.fuelLit,
    required this.desc,
    required this.image,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddAddressPopupState createState() => _AddAddressPopupState();
}

class _AddAddressPopupState extends State<AddAddressPopup> {
  String selectedImagePath = '';
  String loadingStatus = '';
  String loginToken = '';
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool isLoading = false;
  List<String> selectedItemsNames = [];
  Map<String, dynamic> addressStateDataList = {};
  List<String> selectedCountryStateName = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Batticaloa',
    'Trincomalee',
    'Mannar',
    'Mullaitivu',
    'Kilinochchi',
    'Vavuniya',
    'Puttalam',
    'Kurunegala',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Monaragala',
    'Ratnapura',
    'Kegalle'
  ];

  List<dynamic> addressDataStateJson = [];
  List<dynamic> addressDataAreaJson = [];
  final TextEditingController _controllerAddressLine1 = TextEditingController();
  final TextEditingController _controllerAddressLine2 = TextEditingController();
  final TextEditingController _controllerAddressLine3 = TextEditingController();
  final TextEditingController _controllerPostal = TextEditingController();
  String dropdownvalue = ('No option');
  String dropdownstatevalue = ('No option');
  String dropdownareavalue = ('No option');
  double logtitude = 0.0;
  double latitude = 0.0;
  int _stateuser = 0;
  int _areauser = 0;
  String resourceusername = '';
  final _formKey = GlobalKey<FormState>();
  final _validateService = ValidateService();

  handleCountryStateSelect(String? value) {
    setState(() {
      dropdownstatevalue = value!;

      _stateuser = selectedCountryStateName.indexOf(value);
    });
  }

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
                      controller: _controllerAddressLine1,
                      hintText: 'Address Line 1',
                      validate: (value) =>
                          _validateService.isEmptyField(value!),
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
                    child: CustomTextField(
                      controller: _controllerAddressLine2,
                      hintText: 'Address Line 2',
                      validate: (value) =>
                          _validateService.isEmptyField(value!),
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
                    child: CustomTextField(
                      controller: _controllerAddressLine3,
                      hintText: 'Address Line 3',
                      validate: (value) =>
                          _validateService.isEmptyField(value!),
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
                      child: DropDownStateTextfield(
                        countryNames: selectedCountryStateName,
                        handleMakeSelect: handleCountryStateSelect,
                        hintText: 'Districs :',
                        dropdownvalue: dropdownstatevalue,
                      ),
                    ),
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
                      controller: _controllerPostal,
                      hintText: 'Postal Code',
                      validate: (value) => _validateService.postalCode(value!),
                    ),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: relativeHeight * 50.0,
                    left: relativeWidth * 120.0,
                    right: relativeWidth * 120.0,
                  ),
                  child: Center(
                    child: ButtonWidget(
                      onPressed: () {
                        print('object ${dropdownstatevalue == 'No option'}');
                        final isValidForm = _formKey.currentState!.validate();

                        if (isValidForm) {
                          if (dropdownstatevalue != 'No option') {
                            Navigator.of(context).push(
                              createRoute(
                                  SignupScreen(
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    phoneNum: widget.phoneNum,
                                    role: widget.role,
                                    stationName: widget.stationName,
                                    fuelLit: widget.fuelLit,
                                    desc: widget.desc,
                                    image: widget.image,
                                    address:
                                        '${_controllerAddressLine1.text}, ${_controllerAddressLine2.text}, ${_controllerAddressLine3.text}, $dropdownstatevalue, ${_controllerPostal.text.toString()}',
                                  ),
                                  TransitionType.rightToLeft),
                            );
                          } else {
                            showErrorDialog(context, 'Please select district');
                          }
                        } else {
                          showErrorDialog(context, 'Please fill the field');
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
        ),
      ),
    );
  }

  Widget _buildTextField(
      String title, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0x6022242E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.only(left: 28, top: 20, bottom: 20),
          fillColor: const Color(0xFFFFFFFF),
          filled: true,
        ),
        // validator: validate,
      ),
    );
  }
}
