import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class OrderService {
  Future<void> updateOrderWithPaymentId(Map<String, dynamic> orderData) async {
    try {
      // Fetch the existing order data
      DatabaseReference placeOrderRef = FirebaseDatabase.instance
          .ref()
          .child('Order')
          .child(orderData['referenceNo']);

      // Save the updated order data with the paymentId
      await placeOrderRef.set(orderData);
    } catch (error) {
      print('Error updating order data: $error');
    }
  }
}
