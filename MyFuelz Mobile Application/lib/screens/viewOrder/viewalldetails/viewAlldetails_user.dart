import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/globle/constants.dart';

import '../../reviewScreen.dart';
import '../../tankerProfileView.dart';

class ViewAllUserOrders extends StatefulWidget {
  final Map<String, dynamic> orderData;
  const ViewAllUserOrders({
    Key? key,
    required this.orderData,
  }) : super(key: key);

  @override
  State<ViewAllUserOrders> createState() => _ViewAllUserOrdersState();
}

class _ViewAllUserOrdersState extends State<ViewAllUserOrders> {
  String loadingStatus = '';
  String dropdownareavalue = ('No option');
  String loginToken = '';





  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: relativeWidth * 500,
        child: Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const DefaultText(
                        content: 'Order Details',
                        fontSizeR: 20,
                        colorR: Colors.black,
                        textAlignR: TextAlign.start,
                        fontWeightR: FontWeight.bold,
                      ),
                      InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildOrderDetailItem("Email", "${widget.orderData['stationDetails']['email']}"),
                _buildOrderDetailItem("Name", "${widget.orderData['stationDetails']['name']}"),
                _buildOrderDetailItem("Phone Number", "${widget.orderData['stationDetails']['phoneNumber']}"),
                _buildOrderDetailItem("Reference Number", "${widget.orderData['referenceNo']}"),
                _buildOrderDetailItem("Payment ID", "${widget.orderData['paymentId']}"),
                _buildOrderDetailItem("Required Liters", "${widget.orderData['requestedLiters']}"),
                _buildOrderDetailItem("Delivery Date", "${widget.orderData['selectDate']}"),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TankerProfileView(

                                tankerId: widget.orderData['stationDetails']['id'],
                            )
                            )
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5,),
                              Text('PROFILE'),
                            ],
                          )
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(
                              bookingData: widget.orderData,

                                customerId: FirebaseAuth.instance.currentUser!.uid,
                                serviceProviderId: widget.orderData['stationDetails']['id'],
                                bookingId: widget.orderData['referenceNo']
                            )
                            )
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow,),
                              SizedBox(width: 5,),
                              Text('RATE', style: TextStyle(),)
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultText(
            content: label + ":",
            fontSizeR: 16,
            colorR: Colors.black,
            textAlignR: TextAlign.start,
            fontWeightR: FontWeight.bold,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultText(
              content: value,
              fontSizeR: 16,
              colorR: Colors.black,
              textAlignR: TextAlign.start,
              fontWeightR: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
