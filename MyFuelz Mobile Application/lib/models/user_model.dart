import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final DatabaseReference _userReference =
      FirebaseDatabase.instance.reference().child('users');
  final DatabaseReference _tankerReference =
      FirebaseDatabase.instance.reference().child('fuel');
  final DatabaseReference _tokenReference =
      FirebaseDatabase.instance.reference().child('tokens');

  Future<Map<String, dynamic>> getUser(String? uid) async {
    DatabaseEvent event = await _userReference.child(uid.toString()).once();
    DataSnapshot snapshot = event.snapshot;
    // log('snap ${snapshot.value}');
    if (snapshot.value != null) {
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(snapshot.value as Map);
      // print('user data $userData');
      return userData;
    }

    return {};
  }

  Future<Map<String, dynamic>> getTanker(String? uid) async {
    DatabaseEvent event = await _tankerReference.child(uid.toString()).once();
    DataSnapshot snapshot = event.snapshot;
    // log('snap ${snapshot.value}');
    if (snapshot.value != null) {
      Map<String, dynamic> fuelData =
          Map<String, dynamic>.from(snapshot.value as Map);
      // print('fuel data $fuelData');
      return fuelData;
    }

    return {};
  }

  Future<Map<String, dynamic>> getToken(String? uid) async {
    DatabaseEvent event = await _tokenReference.child(uid.toString()).once();
    DataSnapshot snapshot = event.snapshot;
    // log('snap ${snapshot.value}');
    if (snapshot.value != null) {
      Map<String, dynamic> tokenData =
          Map<String, dynamic>.from(snapshot.value as Map);
      // print('fuel data $tokenData');
      return tokenData;
    }

    return {};
  }
}
