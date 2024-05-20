import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/text_feild.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/staus/error.dart';
import 'package:myfuelz/screens/main_page.dart';
import 'package:myfuelz/screens/role_selectedScreen.dart';
import 'package:myfuelz/services/validate_service.dart';
import '../components/common/default_text.dart';
import '../components/common/image_button.dart';
import '../components/common/password_feild.dart';
import '../components/common/progess_bar.dart';
import '../globle/page_transition.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = "";
  bool isLoading = false;
  double progressValue = 0.0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _validateService = ValidateService();
  bool isHiddenPassword = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<SharedPreferences> initPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> storeToken(String token) async {
    final prefs = await initPrefs();
    await prefs.setString('authToken', token);
  }

  Future signInWithEmailAndPasswordFirebase({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future signInWithEmailAndPassword() async {
    final isValidForm = _formKey.currentState!.validate();

    if (isValidForm) {
      try {
        setState(() {
          isLoading = true;
        });
        await signInWithEmailAndPasswordFirebase(
            email: _emailController.text, password: _passwordController.text);
        setState(() {
          isLoading = false;
        });
        User user = FirebaseAuth.instance.currentUser!;
        String token = user.uid;
        log('tokennnnnnnn111111111111 $token');
        if (mounted) {
          await storeToken(token);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(
                indexPage: 0,
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
      _emailController.text.isEmpty || _passwordController.text.isEmpty
          ? showErrorDialog(context, 'Please fill the field')
          : _validateService.validateEmail(_emailController.text) != null
              ? showErrorDialog(context, 'Please enter valid email')
              : _validateService.validatePassword(_passwordController.text) !=
                      null
                  ? showErrorDialog(context, 'Please enter valid password')
                  : null;
    }
  }

  googleButton() async {
    setState(() {
      isLoading = true;
      progressValue = 0.2;
    });
    await AuthService().signInWithGoogle((progress) {
      setState(() {
        progressValue = progress;
      });
    }, context, '', '', 'login', '', '', '', '', '', '');
  }

  facebookButton() async {
    setState(() {
      isLoading = true;
      progressValue = 0.2;
    });

    await AuthService().signInWithFacebook((progress) {
      setState(() {
        progressValue = progress;
      });
    }, context, '', '', 'login', '', '', '', '', '', '');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return false;
      },
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
            : FadeTransition(
                opacity: _controller,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: relativeHeight * 50.0,
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
                                content: 'Login To Your Account',
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
                              top: relativeHeight * 40.0,
                              left: relativeWidth * 120.0,
                              right: relativeWidth * 120.0,
                            ),
                            child: Center(
                              child: ButtonWidget(
                                onPressed: signInWithEmailAndPassword,
                                minHeight: relativeHeight * 60,
                                buttonName: 'Login',
                                tcolor: Colors.white,
                                bcolor: const Color(0xFF154478),
                                borderColor: Colors.white,
                                radius: 15,
                                fcolor: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
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
                                top: relativeHeight * 30.0,
                                left: relativeWidth * 29.0,
                                right: relativeWidth * 29.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  createRoute(const RoleSelectedScreen(),
                                      TransitionType.downToUp),
                                );
                              },
                              child: const DefaultText(
                                content: "Don't have an Account? Sign Up",
                                fontSizeR: 16,
                                colorR: Color(0xFF22242E),
                                textAlignR: TextAlign.center,
                                fontWeightR: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
