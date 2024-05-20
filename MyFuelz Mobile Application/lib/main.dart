import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myfuelz/globle/theme.dart';
import 'package:myfuelz/store/application_state.dart';
import 'package:myfuelz/store/root_reducer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'services/auth_service.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backGroundMessageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<ApplicationState> _store = Store<ApplicationState>(rootReducer,
      initialState: ApplicationState.initial());
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (BuildContext context) {
            return AuthService().handleAuthState();
          },
        ),
        // home: OTPScreen(),
      ),





    );
  }
}

Future<void> _backGroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('background msg');
}
