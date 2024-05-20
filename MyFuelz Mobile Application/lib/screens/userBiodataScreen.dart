import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfuelz/components/common/backbutton.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/common/phoneNumber_field.dart';
import 'package:myfuelz/components/common/text_feild.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/screens/role_selectedScreen.dart';
import 'package:myfuelz/screens/signup.dart';
import 'package:myfuelz/screens/stationDataScreen.dart';
import 'package:myfuelz/services/validate_service.dart';

import '../globle/page_transition.dart';
import '../globle/staus/error.dart';

class UserBioDataScreen extends StatefulWidget {
  final String role;
  const UserBioDataScreen({super.key, required this.role});

  @override
  State<UserBioDataScreen> createState() => _UserBioDataScreenState();
}

class _UserBioDataScreenState extends State<UserBioDataScreen> {
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  final _validateService = ValidateService();

  final _formKey = GlobalKey<FormState>();

  // image picker
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
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
                content: 'Fill in your bio to get started',
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
                    'This data will be displayed in your account profile for security',
                fontSizeR: 15,
                fontWeightR: FontWeight.w400,
                textAlignR: TextAlign.start,
              ),
            ),
            SizedBox(height: 20,),

            Center(
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(70),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff7DDCFB),
                      Color(0xffBC67F2),
                      Color(0xffACF6AF),
                      Color(0xffF95549),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/avatar.png'),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 65,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                  controller: _firstNameController,
                  hintText: 'First Name',
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
                child: CustomTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
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
                child: PhoneNumberTextField(
                  controller: _phoneNumberController,
                  hintText: 'Mobile Number',
                  validate: (value) =>
                      _validateService.validatePhoneNumber(value!),
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
                    if (isValidForm) {

                      if (_image != null) {

                        widget.role == 'Tanker'
                            ? Navigator.of(context).push(
                          createRoute(
                            StationDataScreen(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phoneNum: _phoneNumberController.text,
                              role: widget.role,
                              image: _image,
                            ),
                            TransitionType.rightToLeft,
                          ),
                        )
                            : Navigator.of(context).push(
                          createRoute(
                            SignupScreen(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phoneNum: _phoneNumberController.text,
                              role: widget.role,
                              stationName: '',
                              fuelLit: '',
                              desc: '',
                              address: '',
                              image: _image, // Pass image data
                            ),
                            TransitionType.rightToLeft,
                          ),
                        );
                      } else {
                        _firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty ||
                            _phoneNumberController.text.isEmpty
                            ? showErrorDialog(context, 'Please fill the field')
                            : _validateService.validatePhoneNumber(
                            _phoneNumberController.text) !=
                            null
                            ? showErrorDialog(context,
                            'Please enter valid phone number\n(+94 11 1234567)')
                            : null;
                      }
                    } else {

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

//image picker
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  print('${_file?.path}');
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}