import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myfuelz/globle/staus/error.dart';
import 'package:myfuelz/globle/staus/sucess.dart';
import 'package:myfuelz/screens/login.dart';
import 'package:myfuelz/screens/otpScreen.dart';
import 'package:myfuelz/services/fuel_service.dart';
import 'package:myfuelz/services/user_service.dart';
import 'package:myfuelz/services/validate_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/common/backbutton.dart';
import '../components/common/button.dart';
import '../components/common/default_text.dart';
import '../components/common/image_button.dart';
import '../components/common/password_feild.dart';
import '../components/common/progess_bar.dart';
import '../components/common/text_feild.dart';
import '../globle/constants.dart';
import '../globle/page_transition.dart';
import '../services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignupScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String role;
  final String fuelLit;
  final String stationName;
  final String desc;
  final String address;
  final Uint8List? image;

  const SignupScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phoneNum,
    required this.role,
    required this.stationName,
    required this.fuelLit,
    required this.desc,
    required this.address,
    required this.image,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = "";
  bool isLoading = false;
  double progressValue = 0.0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _validateService = ValidateService();
  bool isHiddenPassword = true;
  final UserService _userService = UserService();
  final FuelService _fuelService = FuelService();

  bool isHiddenConfirmPassword = true;

  Future createUserWithEmailAndPasswordFirebase({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }



  Future<String> uploadImageToFirebaseStorage(Uint8List imageBytes) async {

    String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';


    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref().child('customer_profile_pic').child(fileName);
    firebase_storage.UploadTask uploadTask = ref.putData(imageBytes);


    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageURL = await taskSnapshot.ref.getDownloadURL();

    return imageURL;
  }

  Future createUserWithEmailAndPassword() async {
    final isValidForm = _formKey.currentState!.validate();

    if (isValidForm) {
      if (_passwordController.text.toString() ==
          _confirmPasswordController.text.toString()) {
        try {
          setState(() {
            isLoading = true;
          });


          String imageURL = await uploadImageToFirebaseStorage(widget.image!);


          await createUserWithEmailAndPasswordFirebase(
              email: _emailController.text, password: _passwordController.text);

          if (mounted) {
            setState(() {
              isLoading = false;
            });
            List<String> parts = _emailController.text.split('@');


            _userService.addUserDetails(
              '${widget.firstName} ${widget.lastName}',
              _emailController.text.trim(),
              widget.role,
              widget.phoneNum,
              imageURL,
            );

            if (widget.role == 'Tanker') {
              _fuelService.addFuelStationDetails(
                widget.stationName,
                widget.fuelLit,
                widget.desc,
                FirebaseAuth.instance.currentUser!.uid,
                widget.address,
                imageURL,
              );
            }

            // Show success dialog
            showSuccessDialog(
              context,
              'Successfully registered. Please verify your email',
              'Verify',
                  () => Navigator.of(context).push(
                createRoute(
                  OTPScreen(
                    email: _emailController.text,
                    name: parts[0],
                  ),
                  TransitionType.downToUp,
                ),
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            isLoading = false;
            errorMessage = e.message;
          });
          showErrorDialog(context, errorMessage!);
        }
      } else {
        showErrorDialog(context, 'Confirmed password is not matched');
      }
    } else {
      // Handle form validation errors
      // ...
    }
  }


  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      isHiddenConfirmPassword = !isHiddenConfirmPassword;
    });
  }

  googleButton() async {
    setState(() {
      isLoading = true;
      progressValue = 0.2;
    });

    String imageURL = await uploadImageToFirebaseStorage(widget.image!);

    await AuthService().signInWithGoogle(
      (progress) {
        setState(() {
          progressValue = progress;
        });
      },
      context,
      widget.role,
      widget.phoneNum,
      'signup',
      '${widget.firstName} ${widget.lastName}',
      widget.stationName,
      widget.fuelLit,
      widget.desc,
      widget.address,
        imageURL
    );
  }

  facebookButton() async {
    setState(() {
      isLoading = true;
      progressValue = 0.2;
    });

    String imageURL = await uploadImageToFirebaseStorage(widget.image!);

    await AuthService().signInWithFacebook(
      (progress) {
        setState(() {
          progressValue = progress;
        });
      },
      context,
      widget.role,
      widget.phoneNum,
      'signup',
      '${widget.firstName} ${widget.lastName}',
      widget.stationName,
      widget.fuelLit,
      widget.desc,
      widget.address,
        imageURL
    );
  }

  Future<bool> _onWillPop() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: relativeHeight * 20.0,
                      left: relativeWidth * 120.0,
                      right: relativeWidth * 120.0,
                    ),
                    child: CommonProgressBar(
                      percentage: progressValue,
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
                            // top: relativeHeight * 50.0,
                            left: relativeWidth * 120.0,
                            right: relativeWidth * 120.0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: const Image(
                              image: AssetImage('assets/logo_bg.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 20.0,
                            left: relativeWidth * 69.0,
                            right: relativeWidth * 69.0,
                          ),
                          child: const Center(
                            child: DefaultText(
                              colorR: Color.fromRGBO(21, 68, 120, 1),
                              content: 'Myfuelz',
                              fontSizeR: 40,
                              fontWeightR: FontWeight.w900,
                              textAlignR: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 50.0,
                            left: relativeWidth * 70.0,
                            right: relativeWidth * 70.0,
                          ),
                          child: const Center(
                            child: DefaultText(
                              colorR: Color(0xFF22242E),
                              content: 'Make Your Account',
                              fontSizeR: 20,
                              fontWeightR: FontWeight.w600,
                              textAlignR: TextAlign.center,
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
                            child: CustomTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              validate: (value) =>
                                  _validateService.validateEmail(value!),
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
                            child: CustomPasswordField(
                              controller: _passwordController,
                              hintText: 'Password',
                              validate: (value) =>
                                  _validateService.validatePassword(value!),
                              togglePasswordView: _togglePasswordView,
                              isHidden: isHiddenPassword,
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
                            child: CustomPasswordField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirm Password',
                              validate: (value) =>
                                  _validateService.validatePassword(value!),
                              togglePasswordView: _toggleConfirmPasswordView,
                              isHidden: isHiddenConfirmPassword,
                            ),
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 60.0,
                            left: relativeWidth * 120.0,
                            right: relativeWidth * 120.0,
                          ),
                          child: Center(
                            child: ButtonWidget(
                              onPressed: createUserWithEmailAndPassword,
                              minHeight: relativeHeight * 60,
                              buttonName: 'Create Account',
                              tcolor: Colors.white,
                              bcolor: const Color(0xFF154478),
                              borderColor: Colors.white,
                              radius: 15,
                              fcolor: Colors.grey,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: relativeHeight * 30.0,
                                left: relativeWidth * 29.0,
                                right: relativeWidth * 29.0),
                            child: const DefaultText(
                              content: "Or Continue With",
                              fontSizeR: 16,
                              colorR: Color(0xFF22242E),
                              textAlignR: TextAlign.center,
                              fontWeightR: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 30.0,
                            left: relativeWidth * 20.0,
                            right: relativeWidth * 20.0,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageButton(
                                  onPressed: googleButton,
                                  minHeight: relativeHeight * 20,
                                  tcolor: Colors.white,
                                  bcolor: const Color(0xFF154478),
                                  borderColor: Colors.white,
                                  radius: 15,
                                  fcolor: Colors.grey,
                                  imagePath: 'assets/google.png',
                                ),
                                SizedBox(
                                  width: relativeWidth * 20,
                                ),
                                ImageButton(
                                  onPressed: facebookButton,
                                  minHeight: relativeHeight * 20,
                                  tcolor: Colors.white,
                                  bcolor: const Color(0xFF154478),
                                  borderColor: Colors.white,
                                  radius: 15,
                                  fcolor: Colors.grey,
                                  imagePath: 'assets/facebook.png',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: relativeHeight * 20.0,
                              bottom: relativeHeight * 40.0,
                              left: relativeWidth * 29.0,
                              right: relativeWidth * 29.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                createRoute(const LoginScreen(),
                                    TransitionType.upToDown),
                              );
                            },
                            child: const Center(
                              child: DefaultText(
                                content: "already have an account? Sign In",
                                fontSizeR: 16,
                                colorR: Color(0xFF22242E),
                                textAlignR: TextAlign.center,
                                fontWeightR: FontWeight.w500,
                              ),
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
