import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/staus/sucess.dart';
import 'package:dio/dio.dart';
import '../components/common/otp_field.dart';
import '../components/common/progess_bar.dart';
import '../globle/page_transition.dart';
import '../globle/staus/error.dart';
import 'login.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final String name;
  const OTPScreen({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers and focus nodes for OTP fields
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  String? otp;

  var isLoading = true;
  double progressValue = 0.0;
  late Timer _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    focusNode1.requestFocus();
    _generateAndStoreOTP();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
      (Timer timer) {
        if (_secondsRemaining == 0) {
          timer.cancel();
          showErrorDialog(context,
              'Time\'s up! Please click \'Resend\' to generate a new OTP.');
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      },
    );
  }

  String getCombinedOTP() {
    return '${controller1.text}${controller2.text}${controller3.text}${controller4.text}';
  }

  @override
  void dispose() {
    _timer.cancel();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }

  Future<void> _generateAndStoreOTP() async {
    try {
      final String generatedOTP = generateRandom4DigitOTP();
      setState(() {
        otp = generatedOTP;
        postOTPData();
        isLoading = false;
        print('otpppp $otp');
      });
    } catch (error) {
      print('Error generating OTP: $error');
    }
  }

  String generateRandom4DigitOTP() {
    final random = Random.secure();
    final digits = List<int>.generate(4, (_) => random.nextInt(10));
    _secondsRemaining = 120;
    return digits.join();
  }

  Future<void> postOTPData() async {
    const String _apiKey =
        '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';
    setState(() {
      isLoading = true;
    });

    try {
      // Prepare the data to be sent in the request
      var emailData = {
        "personalizations": [
          {
            "to": [
              {"email": widget.email}
            ],
            "subject": "MyfuelZ",
            "dynamic_template_data": {"name": widget.name, "otp": otp}
          }
        ],
        "template_id": "d-311e0be7d5fd4da3b27cd22756a2ba38",
        "from": {"email": "fuelzmy@gmail.com", "name": "Myfuelz"},
        "reply_to": {"email": "fuelzmy@gmail.com", "name": "Myfuelz"}
      };

      // Convert the data to JSON format
      String jsonData = jsonEncode(emailData);

      // Make the POST request
      Response response = await Dio().post(
        'https://api.sendgrid.com/v3/mail/send',
        data: jsonData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
          },
        ),
      );

      if (response.statusCode == 202) {
        setState(() {
          isLoading = false;
          print("success");
        });
        print("Email sent successfully");
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleChange(String enteredDigit) {
    final int codeLength = 4;

    if (enteredDigit.isEmpty) {
      return; // Handle empty input if needed
    }

    if (enteredDigit.length > 1) {
      // Handle invalid input with more than one digit
      return;
    }
    if (enteredDigit.isNotEmpty) {
      FocusScope.of(context).nextFocus();
    }
  }

  // Add more refined form validation based on your actual requirements
  bool _validateForm() {
    return (
        // Add your validation logic here
        controller1.text.isNotEmpty &&
            controller2.text.isNotEmpty &&
            controller3.text.isNotEmpty &&
            controller4.text.isNotEmpty);
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
      child: SafeArea(
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
              : SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: relativeHeight * 20.0,
                        //     left: relativeWidth * 30.0,
                        //   ),
                        //   child: BackButtonWidget(),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 40.0,
                            left: relativeWidth * 30.0,
                          ),
                          child: const DefaultText(
                            colorR: Color(0xFF22242E),
                            content: 'Verification Code',
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
                          child: DefaultText(
                            colorR: Color(0xFF22242E),
                            content:
                                'We have sent the code of verification to \n${widget.email}',
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: OTPField(
                                      controller: controller1,
                                      focusNode: focusNode1,
                                      hintText: "1",
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter a digit";
                                        } else if (value.length > 1) {
                                          return "Only one digit allowed";
                                        }
                                        return null;
                                      },
                                      onchange: (digit) => _handleChange(digit),
                                    ),
                                  ),
                                  SizedBox(width: relativeWidth * 10),
                                  Expanded(
                                    child: OTPField(
                                      controller: controller2,
                                      focusNode: focusNode2,
                                      hintText: "2",
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter a digit";
                                        } else if (value.length > 1) {
                                          return "Only one digit allowed";
                                        }
                                        return null;
                                      },
                                      onchange: _handleChange,
                                    ),
                                  ),
                                  SizedBox(width: relativeWidth * 10),
                                  Expanded(
                                    child: OTPField(
                                      controller: controller3,
                                      focusNode: focusNode3,
                                      hintText: "3",
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter a digit";
                                        } else if (value.length > 1) {
                                          return "Only one digit allowed";
                                        }
                                        return null;
                                      },
                                      onchange: _handleChange,
                                    ),
                                  ),
                                  SizedBox(width: relativeWidth * 10),
                                  Expanded(
                                    child: OTPField(
                                      controller: controller4,
                                      focusNode: focusNode4,
                                      hintText: "4",
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter a digit";
                                        } else if (value.length > 1) {
                                          return "Only one digit allowed";
                                        }
                                        return null;
                                      },
                                      onchange: _handleChange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: relativeWidth * 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 20.0,
                            left: relativeWidth * 25.0,
                            right: relativeWidth * 25.0,
                          ),
                          child: Center(
                            child: DefaultText(
                              colorR: Color(0xFF22242E),
                              content:
                                  '$_secondsRemaining seconds left to submit OTP',
                              fontSizeR: 15,
                              fontWeightR: FontWeight.w400,
                              textAlignR: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: relativeHeight * 120.0,
                            left: relativeWidth * 20.0,
                            right: relativeWidth * 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () {
                                    _generateAndStoreOTP();
                                    startTimer();
                                    controller1.clear();
                                    controller2.clear();
                                    controller3.clear();
                                    controller4.clear();
                                    _secondsRemaining = 120;
                                  },
                                  minHeight: relativeHeight * 75,
                                  buttonName: 'Resend',
                                  tcolor: const Color(0xFF154478),
                                  bcolor: const Color(0x21154378),
                                  borderColor: Colors.white,
                                  radius: 15,
                                  fcolor: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: relativeWidth * 20,
                              ),
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    final isValidForm =
                                        _formKey.currentState!.validate();

                                    if (isValidForm) {
                                      if (_secondsRemaining != 0) {
                                        if (getCombinedOTP() == otp) {
                                          showSuccessDialog(
                                            context,
                                            'Email Verify Successfully',
                                            'Login',
                                            () => Navigator.of(context).push(
                                              createRoute(const LoginScreen(),
                                                  TransitionType.downToUp),
                                            ),
                                          );
                                        } else {
                                          showErrorDialog(context,
                                              'Please enter correct OTP');
                                        }
                                      } else {
                                        showErrorDialog(context,
                                            'Time\'s up! Please click \'Resend\' to generate a new OTP.');
                                      }
                                    } else {
                                      showErrorDialog(
                                          context, 'Please fill the field');
                                    }
                                  },
                                  minHeight: relativeHeight * 75,
                                  buttonName: 'Confirm',
                                  tcolor: Colors.white,
                                  bcolor: const Color(0xFF154478),
                                  borderColor: Colors.white,
                                  radius: 15,
                                  fcolor: Colors.grey,
                                ),
                              ),
                            ],
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
