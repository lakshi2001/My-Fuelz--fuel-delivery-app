import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myfuelz/components/common/progess_bar.dart';
import 'package:myfuelz/screens/home_page.dart';
import 'package:myfuelz/screens/tankerHomePage.dart';
import 'package:myfuelz/screens/updatebio/tanker.dart';
import 'package:myfuelz/screens/updatebio/user.dart';
import '../chat/inbox_page.dart';
import '../components/common/progess_bar.dart';
import '../globle/constants.dart';
import '../globle/page_transition.dart';
import '../globle/staus/sucess.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../store/application_state.dart';
import '../store/userDetails/userDetails_action.dart';
import 'login.dart';
import 'viewOrder/viewOrder_tanker.dart';
import 'viewOrder/viewOrder_user.dart';

class MainPage extends StatefulWidget {
  final int indexPage;
  const MainPage({
    Key? key,
    required this.indexPage,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  bool isLoading = false;
  double progressValue = 0.0;
  Map<String, dynamic> currentUser = {};
  Map<String, dynamic> fuelDetails = {};
  final UserService _userService = UserService();
  final UserModel _userModel = UserModel();
  static String? token;
  final NotificationService _notificationServices = NotificationService();

  @override
  void initState() {
    super.initState();
    _index = widget.indexPage;
    setState(() {
      isLoading = true;
      _getToken();
    });
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('authToken')) {
      token = prefs.getString('authToken');
      log('Retrieved token: $token');
      progressValue = 0.5;
      _userModel.getUser(token).then((featuredUserList) {
        setState(() {
          currentUser = featuredUserList;
          // log('curnrtttttt ${currentUser['email']}');
          StoreProvider.of<ApplicationState>(
            context,
            listen: false,
          ).dispatch(
            UserDetails(
              email: currentUser['email'],
              name: currentUser['name'],
              phoneNumber: currentUser['phone'],
              role: currentUser['role'],
              userID: currentUser['uid'],
            ),
          );
          progressValue = 0.7;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        Center(
          child: Text(
            "We are facing internal issue: ${error.toString()}",
            style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        );
      });
      progressValue = 0.75;
      // Future.delayed(const Duration(seconds: 2), () {
      // if (currentUser['role'] == 'Tanker') {
      _userModel.getTanker(token).then((featuredFuel) {
        setState(() {
          fuelDetails = featuredFuel;
          // log('fuelll ${fuelDetails['stationName']}');
          StoreProvider.of<ApplicationState>(
            context,
            listen: false,
          ).dispatch(
            FuelDetails(
              address: fuelDetails['address'],
              fuelLit: fuelDetails['fuelLit'],
              stationName: fuelDetails['stationName'],
              desc: fuelDetails['desc'],
              statID: fuelDetails['uid'],
            ),
          );
          progressValue = 0.9;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        Center(
          child: Text(
            "We are facing internal issue: ${error.toString()}",
            style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        );
      });
      // }
      // });
      _notificationServices.requestNotificationPermission();
      _notificationServices.forgroundMessage();
      // ignore: use_build_context_synchronously
      _notificationServices.firebaseInit(context);
      // ignore: use_build_context_synchronously
      _notificationServices.setupInteractMessage(context);
      _notificationServices.isTokenRefresh();
      if (mounted) {
        _notificationServices.getDeviceToken().then((value) {
          setState(() {
            _notificationServices.saveToken(value, token);
            if (kDebugMode) {
              // print('device token');
              // print(value);
            }
          });
          // featuredToken = tokens;
          // tokenCount = tokens.length;
          // _pushNotificationService.listenOnMessage();
          StoreProvider.of<ApplicationState>(
            context,
            listen: false,
          ).dispatch(
            AssignToken(
              token: [value].toList(),
            ),
          );
          progressValue = 1;
          isLoading = false;
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          // ignore: invalid_return_type_for_catch_error
          return Center(
            child: Text(
              "We are facing internal issue: ${error.toString()}",
              style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          );
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      showSuccessDialog(
        context,
        'Error with login. Please Login Again',
        'Login',
        () => Navigator.of(context).push(
          createRoute(const LoginScreen(), TransitionType.downToUp),
        ),
      );
    }
  }

  void _onStateChanged(bool newIsLoading) {
    setState(() {
      isLoading = newIsLoading;
    });
  }

  Future<bool> _onWillPop() async {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    final value = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Are you sure?'),
        content: const Column(
          children: [
            // Container(
            //   child: Lottie.asset('assets/question_exit.json',
            //       animate: true,
            //       height: relativeHeight * 150,
            //       width: relativeWidth * 150),
            // ),
            Text('Do you want to exit an App.'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            // onPressed: () => SystemNavigator.pop(),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushNamed(context, '/signin');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (value != null) {
      return Future.value(value);
    } else {
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    Widget widget = Container();
    switch (_index) {
      case 0:
        widget = currentUser['role'] == 'Tanker'
            ? TankerHomePage(onLoadingStateChanged: _onStateChanged)
            : HomePage(onLoadingStateChanged: _onStateChanged);
        break;

      case 1:
        widget = currentUser['role'] == 'Tanker'
            ? ViewOrderTanker()
            : ViewOrderUser();
        break;

      case 2: widget = InboxPage();
    }
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
            : widget,
        bottomNavigationBar: Visibility(
          visible: isLoading == false ? true : false,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: relativeWidth * 60.0,
                  vertical: relativeHeight * 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x20154378),
                  // color: const Color.fromRGBO(237, 237, 237, 1),
                  borderRadius: BorderRadius.circular(47),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: relativeWidth * 12.0,
                      vertical: relativeHeight * 12.0),
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: const Color.fromRGBO(237, 237, 237, 1),
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(
                        horizontal: relativeWidth * 20,
                        vertical: relativeHeight * 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Color(0x60154378),
                    color: const Color(0xFF154478),
                    tabs: [
                      GButton(
                        leading: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/Icon Home.png',
                            color: const Color(0xFF154478),
                          ),
                        ),
                        icon: CupertinoIcons.add,
                        text: 'MAIN',
                        textColor: Color(0xFF154478),
                      ),
                      GButton(
                        leading: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/Icon Profile.png',
                            color: const Color(0xFF154478),
                          ),
                        ),
                        icon: CupertinoIcons.add,
                        text: 'PROFILE',
                        textColor: Color(0xFF154478),
                      ),
                      GButton(
                        leading: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.inbox,
                            color: Color(0xFF154478),
                          ),
                        ),
                        icon: CupertinoIcons.add,
                        text: 'INBOX',
                        textColor: Color(0xFF154478),
                      ),
                    ],
                    selectedIndex: _index,
                    onTabChange: (index) {
                      setState(() {
                        _index = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
