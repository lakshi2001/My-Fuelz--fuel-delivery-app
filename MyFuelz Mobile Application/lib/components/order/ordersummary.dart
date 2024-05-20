import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myfuelz/components/common/RefKey.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/screens/main_page.dart';
import 'package:myfuelz/services/notification_service.dart';
import 'package:myfuelz/services/order_service.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../../globle/page_transition.dart';
import '../../globle/staus/error.dart';
import '../../globle/staus/sucess.dart';
import 'package:intl/intl.dart';
import '../../store/application_state.dart';
import '../../store/userDetails/userDetails_state.dart';
import '../common/progess_bar.dart';

// ignore: must_be_immutable
class ViewOrderSummary extends StatefulWidget {
  final double itemCount;
  final String totalprice;
  final String token;
  final String selectDate;

  const ViewOrderSummary({
    super.key,
    required this.itemCount,
    required this.totalprice,
    required this.token,
    required this.selectDate
  });

  @override
  State<ViewOrderSummary> createState() => _ViewOrderSummaryState();
}

class _ViewOrderSummaryState extends State<ViewOrderSummary> {
  String referenceNo = '';
  final RandomKey _randomKey = RandomKey();
  final OrderService _orderService = OrderService();
  final NotificationService _notificationService = NotificationService();
  var isLoading = false;
  double progressValue = 0.0;

  void initiatePayment(
      Map<String, dynamic> orderData, UserDetailsState state) async {
    print("Initiating payment...");
    print("222222222222222222222222222222222222222222222 $referenceNo");

    Map<String, dynamic> paymentObject = {
      "sandbox": true,
      "merchant_id": "1226137",
      "merchant_secret": "NDA1MzY5NzY2NjM5NTE3Mjk0OTYxNjAwMzM1OTMyNjk0NzM2NDQ4",
      "notify_url": "https://payment-app-eta.vercel.app/",
      "order_id": referenceNo,
      "items": widget.itemCount,
      "currency": "LKR",
      "amount": widget.totalprice,
      "first_name": state.selectedName,
      "last_name": state.selectedName,
      "email": state.selectedEmail,
      "phone": state.selectedPhoneNumber,
      "address": state.selectedAdd,
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": state.selectedAdd,
      "delivery_city": 'Colombo',
      "delivery_country": "Sri Lanka",
      "custom_1": "1guh",
      "custom_2": "ygbhj",
    };
    print("Payment Object: $paymentObject");

    PayHere.startPayment(paymentObject, (paymentId) async {
      print("One Time Payment Success. Payment Id: $paymentId");

      // Add the paymentId to the order data
      orderData['paymentId'] = paymentId;
      setState(() {
        isLoading = true;
        progressValue = 0.5;
      });

      await _orderService.updateOrderWithPaymentId(orderData);
      postCheckoutData(state, referenceNo, paymentId);
      await _notificationService.sendPushMessage(
          'Order $referenceNo Placed Succesfuly.', 'order Success!');
      postCheckoutDataToTanker(state, referenceNo, paymentId);
      await _notificationService.sendPushMessageTanker(
          'New Order $referenceNo Recived.', 'New Order!', widget.token);

      // ignore: use_build_context_synchronously
      showSuccessDialog(
        context,
        '"One Time Payment Success. Payment Id: $paymentId"',
        'View',
        () => Navigator.of(context).push(
          createRoute(
              const MainPage(
                indexPage: 1,
              ),
              TransitionType.downToUp),
        ),
      );
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showErrorDialog(context, error);

      // Handle payment failure if needed
    }, () async {
      print("One Time Payment Dismissed");
      showErrorDialog(context, "Payment Dismissed");
    });
  }

  Future<void> postCheckoutData(
      UserDetailsState state, String referenceNo, String paymentId) async {
    const String _apiKey =
        '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';

    try {
      // Prepare the data to be sent in the request
      var emailData = {
        "personalizations": [
          {
            "to": [
              {"email": state.selectedEmail}
            ],
            "subject": "MyfuelZ",
            "dynamic_template_data": {
              "order_num": referenceNo,
              "first_name": state.selectedName,
              "station_add": state.selectedAdd,
              "station_name": state.selectedStationName,
              "station_phone": state.selectedTankerPhoneNumber,
              "station_email": state.selectedTankerEmail,
              "user_name": state.selectedName,
              "card": paymentId,
              "lit": widget.itemCount,
              "total": widget.totalprice
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
          isLoading = false;
          print("success");
        });
        print("Email sent successfully");
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postCheckoutDataToTanker(
      UserDetailsState state, String referenceNo, String paymentId) async {
    const String _apiKey =
        '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';

    try {
      // Prepare the data to be sent in the request
      var emailData = {
        "personalizations": [
          {
            "to": [
              {"email": state.selectedTankerEmail}
            ],
            "subject": "MyfuelZ",
            "dynamic_template_data": {
              "order_num": referenceNo,
              "first_name": state.selectedTankerName,
              "user_name": state.selectedName,
              "user_email": state.selectedEmail,
              "user_phone": state.selectedPhoneNumber,
              "card": paymentId,
              "lit": widget.itemCount,
              "total": widget.totalprice
            }
          }
        ],
        "template_id": "d-0fb0ab18966a4fffa1de8b7127fd9304",
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
          isLoading = false;
          print("success");
        });
        print("Email sent successfully");
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return StoreConnector<ApplicationState, UserDetailsState>(
      converter: (store) => store.state.userDetailsState,
      builder: (context, UserDetailsState state) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: DefaultText(
                  content: 'Order Summary',
                  fontSizeR: 18,
                  colorR: Colors.white,
                  textAlignR: TextAlign.start,
                  fontWeightR: FontWeight.w400),
            ),
            Padding(
              padding: EdgeInsets.only(
                //left: relativeWidth * 10,
                top: relativeHeight * 5,
                //right: relativeWidth * 10
              ),
            ),
            const Divider(
              color: Color.fromRGBO(217, 217, 217, 1),
              thickness: 1, //thickness of divier line
              indent: 10,
              endIndent: 10, //spacing at the end of divider
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DefaultText(
                      content: 'Requested Liters',
                      fontSizeR: 18,
                      colorR: Colors.white,
                      textAlignR: TextAlign.start,
                      fontWeightR: FontWeight.w400),
                  DefaultText(
                      content: widget.itemCount.toString(),
                      fontSizeR: 18,
                      colorR: Colors.white,
                      textAlignR: TextAlign.start,
                      fontWeightR: FontWeight.w400),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultText(
                      content: 'Price Per Liter',
                      fontSizeR: 18,
                      colorR: Colors.white,
                      textAlignR: TextAlign.start,
                      fontWeightR: FontWeight.w400),
                  DefaultText(
                      content: 'Rs.350.00',
                      fontSizeR: 18,
                      colorR: Colors.white,
                      textAlignR: TextAlign.start,
                      fontWeightR: FontWeight.w400),
                ],
              ),
            ),
            Container(
              height: relativeHeight * 80,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DefaultText(
                        content: 'Total',
                        fontSizeR: 18,
                        colorR: Colors.white,
                        textAlignR: TextAlign.start,
                        fontWeightR: FontWeight.w600),
                    DefaultText(
                      content:
                          'Rs.${widget.totalprice}', // Format as two decimal places
                      fontSizeR: 18,
                      colorR: Colors.white,
                      textAlignR: TextAlign.start,
                      fontWeightR: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: relativeHeight * 10.0,
                bottom: relativeHeight * 20.0,
                left: relativeWidth * 20.0,
                right: relativeWidth * 20.0,
              ),
              child: isLoading
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: relativeHeight * 20.0,
                        left: relativeWidth * 20.0,
                        right: relativeWidth * 20.0,
                      ),
                      child: Center(
                        child: CommonProgressBar(
                          percentage: progressValue,
                        ),
                      ),
                    )
                  : Center(
                      child: ButtonWidget(
                        onPressed: () async {
                          referenceNo =
                              await _randomKey.generateRandomProductCode();

                          Map<String, dynamic> buyerDetails = {
                            'name': state.selectedName,
                            'phoneNumber': state.selectedPhoneNumber,
                            'email': state.selectedEmail,
                          };
                          Map<String, dynamic> stationDetails = {
                            'stationName': state.selectedStationName,
                            'address': state.selectedAdd,
                            'id': state.selectedTankerUserId,
                            'phoneNumber': state.selectedTankerPhoneNumber,
                            'email': state.selectedTankerEmail,
                          };
                          Map<String, dynamic> orderData = {
                            'userId': state.selectedUserId,
                            'stationId': state.selectedStatID,
                            'buyerDetails': buyerDetails,
                            'stationDetails': stationDetails,
                            'requestedLiters': widget.itemCount,
                            'total': widget.totalprice,
                            'orderDateTime': DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime.now()),
                            'referenceNo': referenceNo,
                            'selectDate' : widget.selectDate
                          };
                          initiatePayment(orderData, state);
                        },
                        minHeight: relativeHeight * 70,
                        buttonName: 'Place Order',
                        tcolor: Colors.black,
                        bcolor: Colors.white,
                        borderColor: Colors.white,
                        radius: 10,
                        fcolor: Colors.grey,
                      ),
                    ),
            ),
          ]),
    );
  }
}
