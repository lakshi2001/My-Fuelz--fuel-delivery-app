import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfuelz/screens/login.dart';
import 'package:myfuelz/screens/main_page.dart';
import 'package:myfuelz/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final UserService _userService = UserService();

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage(
              indexPage: 0,
            );
          } else {
            if (kDebugMode) {
              print("Loging error detect");
            }
            return const LoginScreen();
          }
        });
  }



  signInWithGoogle(
      Null Function(dynamic progress) onProgress,
      BuildContext context,
      String role,
      String phoneNum,
      String page,
      String name,
      String stationName,
      String fuelLit,
      String desc,
      String address,
      String imageURL,) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>["email"]);

    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    double progressValue = 0.3;
    onProgress(progressValue);

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    progressValue = 0.5;
    onProgress(progressValue);

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var result = await FirebaseAuth.instance.signInWithCredential(credential);
    progressValue = 0.7;
    onProgress(progressValue);

    User? userDetails = result.user;

    _userService.addGoogleUserToFB(userDetails, googleUser, context, role,
        phoneNum, page, name, stationName, fuelLit, desc, address, imageURL);
    progressValue = 1.0;
    onProgress(progressValue);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithFacebook(
      Null Function(dynamic progress) onProgress,
      BuildContext context,
      String role,
      String phoneNum,
      String page,
      String name,
      String stationName,
      String fuelLit,
      String desc,
      String address,
      String imageURL,) async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: (['email', 'public_profile']));
      double progressValue = 0.3;
      onProgress(progressValue);
      //? need to add my account as administrator or tester in facebook devoloper app role
      // print('resulttt ${result.message}');
      final token = result.accessToken!.token;
      print(
          'Facebook token userID : ${result.accessToken!.grantedPermissions}');
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
      progressValue = 0.5;
      onProgress(progressValue);

      final profile = jsonDecode(graphResponse.body);
      try {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);
        log("Profile is equal to $profile");
        double progressValue = 0.7;
        onProgress(progressValue);

        _userService.addFacebookUserToFB(profile, context, role, phoneNum, page,
            name, stationName, fuelLit, desc, address, imageURL);
        progressValue = 1.0;
        onProgress(progressValue);
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("dismiss");
          print(e.toString());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("error occurred");
        print(e.toString());
      }
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
