import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lottie/lottie.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/common/novalidateTextField.dart';
import 'package:myfuelz/components/home/elementCard.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/page_transition.dart';
import 'package:myfuelz/screens/orderDetails.dart';
import 'package:myfuelz/services/auth_service.dart';
import 'package:myfuelz/store/userDetails/userDetails_state.dart';

import '../chat/chat_page.dart';
import '../components/common/backbutton.dart';
import '../components/common/number_field.dart';
import '../globle/staus/error.dart';
import '../store/application_state.dart';
import 'tankerProfileView.dart';

class DetailsScreen extends StatefulWidget {

  final String tankerid;
  DetailsScreen({super.key, required this.tankerid});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String selectedFuelType;

  late Future<DataSnapshot> _tankerFuture; // Future for fetching tanker data

  @override
  void initState() {
    super.initState();
    // Randomly select either petrol or diesel
    selectedFuelType = Random().nextBool() ? 'Petrol' : 'Diesel';

    _tankerFuture = _fetchTankerName();

  }

  Future<DataSnapshot> _fetchTankerName() async {
    // Fetch tanker data
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(widget.tankerid)
        .once()
        .then((snapshot) => snapshot.snapshot);

    // Return the fetched snapshot
    return snapshot;
  }


  // date picker
  DateTime? selectedDate;
  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = pickedDate.toString().split(' ')[0];
      });
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return StoreConnector<ApplicationState, UserDetailsState>(
      converter: (store) => store.state.userDetailsState,
      builder: (context, UserDetailsState state) => SafeArea(
        child: Scaffold(
          body: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([

                    Stack(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: relativeHeight * 20.0,
                                      left: relativeWidth * 30.0,
                                    ),
                                    child: const BackButtonWidget(),
                                  ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: relativeHeight * 40.0,
                                        left: relativeWidth * 30.0,
                                        right: relativeWidth * 30),
                                    child: DefaultText(
                                      colorR: const Color(0xFF22242E),
                                      content: state.selectedStationName,
                                      fontSizeR: 35,
                                      fontWeightR: FontWeight.w400,
                                      textAlignR: TextAlign.start,
                                    ),
                                  ),


                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TankerProfileView(
                                          tankerId: widget.tankerid,
                                      )));
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          top: relativeHeight * 20.0,
                                          right: relativeWidth * 30.0,
                                        ),
                                        child: const Icon(Icons.person, size: 43, color: Color(0xFF154478),)
                                    ),
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       top: relativeHeight * 10.0,
                              //       left: relativeWidth * 30.0,
                              //       right: relativeWidth * 30),
                              //   child: const Row(
                              //     children: [
                              //       Icon(Icons.location_on), // Add location icon
                              //       const SizedBox(width: 8.0),
                              //       Expanded(
                              //         child: DefaultText(
                              //           colorR: Color(0xFF22242E),
                              //           content: '19 km',
                              //           fontSizeR: 16,
                              //           fontWeightR: FontWeight.w400,
                              //           textAlignR: TextAlign.start,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 35,
                                  top: relativeHeight * 20,
                                  right: relativeWidth * 35,
                                ),
                                child: DefaultText(
                                  colorR: Colors.black,
                                  content: state.selectedDesc,
                                  fontSizeR: 12,
                                  fontWeightR: FontWeight.w400,
                                  textAlignR: TextAlign.start,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 35,
                                  top: relativeHeight * 40,
                                  right: relativeWidth * 35,
                                ),
                                child: const DefaultText(
                                  colorR: Colors.black,
                                  content: 'Tanker Left',
                                  fontSizeR: 15,
                                  fontWeightR: FontWeight.w400,
                                  textAlignR: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 35,
                                  top: relativeHeight * 20,
                                  right: relativeWidth * 35,
                                ),
                                child: ElementCard(
                                  name: selectedFuelType,
                                  time: '${state.selectedFuelLit} Liters',
                                  imageurl: 'assets/fuel.png',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 35,
                                  top: relativeHeight * 40,
                                  right: relativeWidth * 35,
                                ),
                                child: const DefaultText(
                                  colorR: Colors.black,
                                  content: 'Request Litters',
                                  fontSizeR: 15,
                                  fontWeightR: FontWeight.w400,
                                  textAlignR: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: relativeHeight * 20.0,
                                  left: relativeWidth * 35.0,
                                  right: relativeWidth * 35.0,
                                ),
                                child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x23154378),
                                            blurRadius: 50,
                                            offset: Offset(12, 26),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: NumberTextField(
                                        controller: _numberController,
                                        hintText: 'Number of Litters Request',
                                        validate: (String? value) {
                                          // Check for null value
                                          if (value == null) {
                                            return 'Please enter a fuel quantity.';
                                          }

                                          // Convert to double for number checking and potential state access
                                          double fuelQuantity;
                                          try {
                                            fuelQuantity = double.parse(value);
                                          } catch (e) {
                                            return 'Invalid fuel quantity. Please enter a valid number.';
                                          }

                                          // Access state (adjust according to your state management setup)
                                          final double tankerLeft =
                                          double.parse(state.selectedFuelLit);

                                          // Validate value is a number
                                          if (fuelQuantity <= 0) {
                                            return 'Fuel quantity must be greater than 0.';
                                          }

                                          // Validate quantity within tanker limit
                                          if (fuelQuantity > tankerLeft) {
                                            return 'Fuel quantity exceeds available fuel. Maximum allowed: $tankerLeft liters.';
                                          }

                                          // Validation successful
                                          return null; // Or a custom success message if needed
                                        },
                                      ),
                                    )),
                              ),


                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 35,
                                  top: relativeHeight * 40,
                                  right: relativeWidth * 35,
                                ),
                                child: const DefaultText(
                                  colorR: Colors.black,
                                  content: 'Select Date',
                                  fontSizeR: 15,
                                  fontWeightR: FontWeight.w400,
                                  textAlignR: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: relativeHeight * 20.0,
                                  left: relativeWidth * 35.0,
                                  right: relativeWidth * 35.0,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x23154378),
                                            blurRadius: 50,
                                            offset: Offset(12, 26),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _dateController,
                                        decoration: const InputDecoration(
                                          labelText: 'Date',
                                          suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF154478),),
                                          labelStyle: TextStyle(color: Colors.grey),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a date.';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),




                              Padding(
                                padding: EdgeInsets.only(
                                    top: relativeHeight * 40.0,
                                    left: relativeWidth * 120.0,
                                    right: relativeWidth * 120.0,
                                    bottom: relativeHeight * 40),
                                child: Center(
                                  child: ButtonWidget(
                                    onPressed: () {
                                      final isValidForm =
                                      _formKey.currentState!.validate();

                                      if (isValidForm) {
                                        Navigator.of(context).push(
                                          createRoute(
                                              OrderDetailsScreen(
                                                requestFuel: double.parse(_numberController.text),
                                                selectDate: _dateController.text,
                                              ),
                                              TransitionType.upToDown),
                                        );
                                      } else {
                                        _numberController.text.isEmpty
                                            ? showErrorDialog(context,
                                            'Please enter a requested fuel quantity')
                                            : null;
                                      }
                                    },
                                    minHeight: relativeHeight * 60,
                                    buttonName: 'Next',
                                    tcolor: Colors.white,
                                    bcolor: const Color(0xFF154478),
                                    borderColor: Colors.white,
                                    radius: 15,
                                    fcolor: Colors.grey,
                                  ),
                                ),
                              ),



                            ]

                        ),
                        Positioned(
                          bottom: 16,
                          right: 2,
                          child: Container(
                            child: FutureBuilder<DataSnapshot>(
                              future: _tankerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.data == null) {
                                  return Text('No data available');
                                } else {

                                  var tankerData = snapshot.data!.value;

                                  if (tankerData != null && tankerData is Map<dynamic, dynamic>) {

                                    return ElevatedButton(
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                              reciverUserId: widget.tankerid,
                                              senderId: FirebaseAuth.instance.currentUser!.uid,
                                              reciverName: tankerData?['name'] ?? 'Unknown',
                                              picture: tankerData?['imageURL'] ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Lottie.network('https://lottie.host/ff71aa2e-8c89-4ab4-b351-72d9476928f3/uNlwLCuD87.json',
                                        height: 50
                                      ),

                                    );
                                  } else {
                                    return const Text('Tanker data is null or invalid.');
                                  }
                                }
                              },
                            )

                          ),
                        ),
                      ],
                    ),

                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
