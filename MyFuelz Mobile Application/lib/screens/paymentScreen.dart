import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myfuelz/store/application_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String loadingStatus = '';
  
  String email = '';

  @override
  void initState() {
        email = StoreProvider.of<ApplicationState>(context, listen: false)
        .state
        .userDetailsState.selectedEmail;
    log("njjfgjf bkdfk $email");
    super.initState();
  }

  Future<void> postCheckoutData() async {
    const String _apiKey =
        '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';
    setState(() {
      loadingStatus = "loading";
    });

    try {
      // Prepare the data to be sent in the request
      var emailData = {
        "personalizations": [
          {
            "to": [
              {"email": "nipuni.diluk@gmail.com"}
            ],
            "subject": "MyfuelZ",
            "dynamic_template_data": {
              "order_num": "12345",
              "first_name": "Nipp",
              "station_add": "57/1, migasaregewaththa, galahitiya, walasmulla",
              "user_name": "Nipuni dil",
              "card": "12345425252442",
              "lit": "20",
              "total": "3500.00"
            }
          }
        ],
        "template_id": "d-7f3d48053b8b473496cdb2c276b4e2b6",
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
          loadingStatus = "";
          print("success");
        });
        print("Email sent successfully");
      }
    } catch (e) {
      print(e);
      setState(() {
        loadingStatus = "error";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text("MyFuelZ")]),
    );
  }
}
