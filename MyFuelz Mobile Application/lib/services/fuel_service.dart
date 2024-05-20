import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FuelService {
  Future addFuelStationDetails(
      String name, String lit, String desc, String id, String address, String imageURL) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('fuel').child(id);

    Map<String, dynamic> userData = {
      'stationName': name,
      'fuelLit': lit,
      'desc': desc,
      'uid': id,
      'address': address,
      'imageURL': imageURL,
    };

    reference.set(userData);
  }

  Future updateFuelLit(String lit, String id) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('fuel').child(id);
    await reference.update({'fuelLit': lit});
  }
}
