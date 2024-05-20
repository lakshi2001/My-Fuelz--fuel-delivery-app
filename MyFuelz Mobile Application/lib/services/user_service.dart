import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfuelz/globle/staus/sucess.dart';
import 'package:myfuelz/screens/otpScreen.dart';
import 'package:myfuelz/screens/signup.dart';
import 'package:myfuelz/services/fuel_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globle/page_transition.dart';
import '../globle/staus/error.dart';
import '../screens/login.dart';
import '../screens/main_page.dart';

class UserService {
  late User user;
  final userDet = FirebaseAuth.instance.currentUser;
  final FuelService _fuelService = FuelService();

  getUserData() {
    User user = userDet as User;
    List<UserInfo> userinfo = user.providerData;
    final uid = userinfo[0].uid;
    if (kDebugMode) {
      print("user info ${userinfo[0]}");
    }
    return uid;
  }

  Future addUserDetails(
      String name, String email, String role, String phoneNum, String imageURL) async {
    user = FirebaseAuth.instance.currentUser!;
    String token = user.uid;
    DatabaseReference reference =
    FirebaseDatabase.instance.reference().child('users').child(token);

    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'uid': token,
      'role': role,
      'phone': phoneNum,
      'imageURL': imageURL,
    };

    await reference.set(userData);
  }


  Future addGoogleUserToFB(
    User? userDetails,
    GoogleSignInAccount googleUser,
    BuildContext context,
    String role,
    String phoneNumber,
    String page,
    String name,
    String stationName,
    String fuelLit,
    String desc,
    String address,
    String imageURL,
  ) async {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(googleUser.id);
    DataSnapshot snapshot = (await reference.once()).snapshot;
    if (page == 'signup') {
      if (snapshot.value == null) {
        List<UserInfo> userinfo = userDetails?.providerData as List<UserInfo>;

        Map<String, dynamic> userData = {
          'name': name,
          'email': userDetails?.email,
          'uid': userinfo[0].uid,
          'role': role,
          'phone': phoneNumber,
          'imageURL': imageURL,
        };

        reference.set(userData);
        if (role == 'Tanker') {
          if (role == 'Tanker') {
            _fuelService.addFuelStationDetails(
                stationName, fuelLit, desc, googleUser.id, address, imageURL);
          }
        }

        showSuccessDialog(
          context,
          'Successfully registered. Please verify your email',
          'Verify',
          () => Navigator.of(context).push(
            createRoute(
                OTPScreen(
                  email: userDetails?.email ?? '',
                  name: name,
                ),
                TransitionType.downToUp),
          ),
        );
      } else {
        showErrorDialog(context, 'Please Use Another Account');
        Navigator.pop(context);
        // Navigator.of(context).push(
        //   createRoute(const SignupScreen(firstName: '', lastName: '', phoneNum: phoneNumber, role: role,), TransitionType.upToDown),
        // );
      }
    } else if (page == 'login') {
      if (snapshot.value == null) {
        showErrorDialog(context, 'Please Create an Account First');
        Navigator.of(context).push(
          createRoute(const LoginScreen(), TransitionType.upToDown),
        );
      } else {
        Future<SharedPreferences> initPrefs() async {
          return await SharedPreferences.getInstance();
        }

        Future<void> storeToken(String token) async {
          final prefs = await initPrefs();
          await prefs.setString('authToken', token);
        }

        await storeToken(googleUser.id);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(
              indexPage: 0,
            ),
          ),
        );
      }
    }
  }

  Future addFacebookUserToFB(
    Map<String, dynamic> profile,
    BuildContext context,
    String role,
    String phoneNumber,
    String page,
    String name,
    String stationName,
    String fuelLit,
    String desc,
    String address,
    String imageURL,
  ) async {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(profile['id']);
    DataSnapshot snapshot = (await reference.once()).snapshot;
    if (page == 'signup') {
      if (snapshot.value == null) {
        Map<String, dynamic> userData = {
          'name': name,
          'email': profile['email'],
          'uid': profile['id'],
          'role': role,
          'phone': phoneNumber,
          'imageURL': imageURL,
        };

        reference.set(userData);
        if (role == 'Tanker') {
          if (role == 'Tanker') {
            _fuelService.addFuelStationDetails(
                stationName, fuelLit, desc, profile['id'], address, imageURL);
          }
        }

        showSuccessDialog(
          context,
          'Successfully registered. Please verify your email',
          'Verify',
          () => Navigator.of(context).push(
            createRoute(
                OTPScreen(
                  email: profile['email'],
                  name: name,
                ),
                TransitionType.downToUp),
          ),
        );
      } else {
        showErrorDialog(context, 'Please Use Another Account');
        Navigator.pop(context);
        // Navigator.of(context).push(
        //   createRoute(const SignupScreen(firstName: '', lastName: '', phoneNum: phoneNumber, role: role,), TransitionType.upToDown),
        // );
      }
    } else if (page == 'login') {
      if (snapshot.value == null) {
        showErrorDialog(context, 'Please Create an Account First');
        Navigator.of(context).push(
          createRoute(const LoginScreen(), TransitionType.upToDown),
        );
      } else {
        Future<SharedPreferences> initPrefs() async {
          return await SharedPreferences.getInstance();
        }

        Future<void> storeToken(String token) async {
          final prefs = await initPrefs();
          await prefs.setString('authToken', token);
        }

        await storeToken(profile['id']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(
              indexPage: 0,
            ),
          ),
        );
      }
    }
  }

  Future updateUser(String id, String name, String phoneNumber) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('users').child(id);
    Map<String, dynamic> userData = {
      'name': name,
      'phone': phoneNumber,
    };
    await reference.update(userData);
  }

  Future updateAddress(
      String id, String address, String station, String desc) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('fuel').child(id);
    Map<String, dynamic> userData = {
      'address': address,
      'stationName': station,
      'desc': desc,
    };
    await reference.update(userData);
  }
}
