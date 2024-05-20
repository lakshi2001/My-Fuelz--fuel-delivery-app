import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class FuelModel {
  final DatabaseReference _tankerReference =
      FirebaseDatabase.instance.reference().child('fuel');

  Future<List<Map<String, dynamic>>> getAllTankers() async {
    List<Map<String, dynamic>> tankersList = [];

    DatabaseEvent event = await _tankerReference.once();

    if (event.snapshot.value != null &&
        event.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic>? allTankersMap =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (allTankersMap != null) {
        allTankersMap.forEach((uid, tankerData) {
          if (tankerData is Map<dynamic, dynamic>) {
            Map<String, dynamic> typedTankerData = {
              "uid": uid,
              "address": tankerData["address"],
              "desc": tankerData["desc"],
              "fuelLit": tankerData["fuelLit"],
              "stationName": tankerData["stationName"],
            };

            tankersList.add(typedTankerData);
          }
        });

        // For debugging/logging
        print('tankersList: $tankersList');
      }
    }

    return tankersList;
  }

  Future<Map<String, Map<String, dynamic>>> getOrders(
      String selectedUserId) async {
    DatabaseReference placeOrderRef =
        FirebaseDatabase.instance.ref().child('Order');

    DatabaseEvent databaseEvent = await placeOrderRef.once();

    if (databaseEvent.snapshot.value != null &&
        databaseEvent.snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> placeOrderData =
          databaseEvent.snapshot.value as Map<dynamic, dynamic>;

      Map<String, Map<String, dynamic>> updatedOrderHistoryData = {};

      placeOrderData.forEach((referenceNo, orderData) {
        if (orderData is Map<dynamic, dynamic>) {
          Map<String, dynamic> typedOrderData =
              orderData.map((key, value) => MapEntry(key.toString(), value));

          if (typedOrderData['stationId'] == selectedUserId) {
            updatedOrderHistoryData[referenceNo] = typedOrderData;
          } else if (typedOrderData['userId'] == selectedUserId) {
            updatedOrderHistoryData[referenceNo] = typedOrderData;
          }
        } else {
          print('Unexpected structure for orderData');
        }
      });

      // log(' dhdhhdhd ${updatedOrderHistoryData}');
      return updatedOrderHistoryData;
    }

    return {};
  }
}
