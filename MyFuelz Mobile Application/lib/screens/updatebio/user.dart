import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myfuelz/components/common/backbutton.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/common/number_field.dart';
import 'package:myfuelz/components/common/password_feild.dart';
import 'package:myfuelz/components/common/phoneNumber_field.dart';
import 'package:myfuelz/components/common/text_feild.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/page_transition.dart';
import 'package:myfuelz/globle/staus/error.dart';
import 'package:myfuelz/globle/staus/sucess.dart';
import 'package:myfuelz/screens/login.dart';
import 'package:myfuelz/screens/viewOrder/viewOrder_user.dart';
import 'package:myfuelz/services/fuel_service.dart';
import 'package:myfuelz/services/user_service.dart';
import 'package:myfuelz/services/validate_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../store/application_state.dart';
import '../../store/userDetails/userDetails_action.dart';
import '../../store/userDetails/userDetails_state.dart';
import '../main_page.dart';

class UserUpdateBioScreen extends StatefulWidget {
  // final String firstName;
  // final String lastName;
  // final String phoneNum;
  // final String role;
  // final String fuelLit;
  // final String stationName;
  // final String desc;

  const UserUpdateBioScreen({
    super.key,
    // required this.firstName,
    // required this.lastName,
    // required this.phoneNum,
    // required this.role,
    // required this.stationName,
    // required this.fuelLit,
    // required this.desc,
  });

  @override
  State<UserUpdateBioScreen> createState() => _UserUpdateBioScreenState();
}

class _UserUpdateBioScreenState extends State<UserUpdateBioScreen> {
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = "";
  bool isLoading = false;
  double progressValue = 0.0;
  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _mobileNumberController = TextEditingController();
  final _validateService = ValidateService();
  bool isHiddenPassword = true;
  final UserService _userService = UserService();
  final FuelService _fuelService = FuelService();

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstNameController = TextEditingController(
          text: StoreProvider.of<ApplicationState>(
        context,
        listen: false,
      ).state.userDetailsState.selectedName);
      _mobileNumberController = TextEditingController(
          text: StoreProvider.of<ApplicationState>(
        context,
        listen: false,
      ).state.userDetailsState.selectedPhoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    return StoreConnector<ApplicationState, UserDetailsState>(
      converter: (store) => store.state.userDetailsState,
      builder: (context, UserDetailsState state) => Scaffold(
        body: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: relativeHeight * 50.0,
                      left: relativeWidth * 120.0,
                      right: relativeWidth * 120.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: const Image(
                        image: AssetImage('assets/logo_bg.png'),
                      ),
                    ),
                  ),
                ],
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
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
                            top: relativeHeight * 50.0,
                            left: relativeWidth * 30.0,
                            right: relativeWidth * 30.0,
                          ),
                          child: const DefaultText(
                            colorR: Color(0xFF22242E),
                            content: 'Update in your bio',
                            fontSizeR: 40,
                            fontWeightR: FontWeight.w600,
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
                              controller: _firstNameController,
                              hintText: 'First Name',
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
                            child: PhoneNumberTextField(
                              controller: _mobileNumberController,
                              hintText: 'Mobile Number',
                              validate: (value) =>
                                  _validateService.validatePhoneNumber(value!),
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 40.0,
                            left: relativeWidth * 120.0,
                            right: relativeWidth * 120.0,
                          ),
                          child: Center(
                            child: ButtonWidget(
                              onPressed: () {
                                _userService.updateUser(
                                  state.selectedUserId,
                                  _firstNameController.text,
                                  _mobileNumberController.text,
                                );
                                StoreProvider.of<ApplicationState>(
                                  context,
                                  listen: false,
                                ).dispatch(
                                  UserDetails(
                                    email: state.selectedEmail,
                                    name: _firstNameController.text,
                                    phoneNumber: _mobileNumberController.text,
                                    role: state.selectedRole,
                                    userID: state.selectedUserId,
                                  ),
                                );

                                Navigator.of(context).pushReplacement(
                                  createRoute(const MainPage(indexPage: 1),
                                      TransitionType.upToDown),
                                );
                              },
                              minHeight: relativeHeight * 60,
                              buttonName: 'Save',
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
      ),
    );
  }
}
