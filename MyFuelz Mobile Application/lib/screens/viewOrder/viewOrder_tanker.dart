import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myfuelz/chat/inbox_page.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/order/orderCard.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/screens/updatebio/user.dart';
import 'package:myfuelz/screens/viewOrder/viewalldetails/viewAlldetails_tanker.dart';
import 'package:myfuelz/screens/viewOrder/viewalldetails/viewAlldetails_user.dart';
import '../../components/common/progess_bar.dart';
import '../../globle/page_transition.dart';
import '../../models/fuel_model.dart';
import '../../services/auth_service.dart';
import '../../store/application_state.dart';
import '../../store/userDetails/userDetails_state.dart';
import '../login.dart';
import '../updatebio/tanker.dart';

class ViewOrderTanker extends StatefulWidget {
  const ViewOrderTanker({super.key});

  @override
  State<ViewOrderTanker> createState() => _ViewOrderTankerState();
}

class _ViewOrderTankerState extends State<ViewOrderTanker> {
  var isLoading = true;
  double progressValue = 0.0;
  List<MapEntry<String, Map<String, dynamic>>> orders = [];
  final FuelModel _fuelModel = FuelModel();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  int _compareDateTimes(dynamic dateTime1, dynamic dateTime2) {
    DateTime? date1 = _parseDateTime(dateTime1);
    DateTime? date2 = _parseDateTime(dateTime2);

    if (date1 != null && date2 != null) {
      return date2.compareTo(date1);
    } else {
      return 0;
    }
  }

  DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime is DateTime) {
      return dateTime;
    } else if (dateTime is String) {
      return DateTime.tryParse(dateTime);
    }

    return null;
  }

  Future<void> _fetchOrders() async {
    try {
      Map<String, Map<String, dynamic>> orderHistoryData =
          await _fuelModel.getOrders(StoreProvider.of<ApplicationState>(
        context,
        listen: false,
      ).state.userDetailsState.selectedUserId);

      // log('ordersssss ${orderHistoryData}');

      setState(() {
        orders = orderHistoryData.entries.toList()
          ..sort((a, b) => _compareDateTimes(
              a.value['orderDateTime'], b.value['orderDateTime']));
        // log('ordersssss ${orders[0]}');

        isLoading = false;
        progressValue = 0.7;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text("We are facing internal issue: ${error.toString()}"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;

    //  Widget cartList() {
    //   return Column(
    //     children: List.generate(3, (index) {
    //       return Column(
    //         children: [
    //          Expanded(
    //               child: OrderCard(
    //                   imageurl: 'assets/Restaurant Image.png',
    //                   itemName: "Spacy fresh crab",
    //                   orderName: "Fuel",
    //                   Orderquantity: "20L")),
    //           if (index < categoryList.length - 1) buildSeparator(index),
    //         ],
    //       );
    //     }),
    //   );
    // }

    // Widget cartList() {
    //   return ListView.builder(
    //     scrollDirection: Axis.vertical,
    //     itemCount: 3,
    //     itemBuilder: (context, index) {
    //       return Row(
    //         children: [
    //           Expanded(
    //               child: OrderCard(
    //                   imageurl: 'assets/Restaurant Image.png',
    //                   itemName: "Spacy fresh crab",
    //                   orderName: "Fuel",
    //                   Orderquantity: "20L")),
    //         ],
    //       );
    //     },
    //   );
    // }

    return StoreConnector<ApplicationState, UserDetailsState>(
      converter: (store) => store.state.userDetailsState,
      builder: (context, UserDetailsState state) => SafeArea(
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DefaultText(
                                  content: state.selectedName,
                                  fontSizeR: 30,
                                  colorR: Colors.black,
                                  textAlignR: TextAlign.start,
                                  fontWeightR: FontWeight.w500,
                                ),
                                DefaultText(
                                  content: state.selectedEmail,
                                  fontSizeR: 16,
                                  colorR: Colors.grey,
                                  textAlignR: TextAlign.start,
                                  fontWeightR: FontWeight.normal,
                                ),
                              ],
                            ),
                            InkResponse(
                              onTap: () {
                                Navigator.of(context).push(
                                  createRoute(const UserUpdateBioScreen(),
                                      TransitionType.rightToLeft),
                                );
                              },
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFF154478),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: relativeHeight * 30,
                          left: relativeWidth * 20,
                        ),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: DefaultText(
                            content: 'Order History',
                            fontSizeR: 25,
                            colorR: Colors.black,
                            textAlignR: TextAlign.start,
                            fontWeightR: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: relativeHeight * 30,
                          left: relativeWidth * 10,
                          right: relativeWidth * 10,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 10,
                                  right: relativeWidth * 10,
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: orders.length,
                                            itemBuilder: (context, index) {
                                              String selectedFuelType =
                                                  Random().nextBool()
                                                      ? 'Petrol'
                                                      : 'Diesel';
                                              Map<String, dynamic> orderData =
                                                  orders[index].value;
                                              return GestureDetector(
                                                onTap: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ViewAllTankerOrders(
                                                        orderData: orderData,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: OrderCard(
                                                    imageurl: 'assets/fuel.png',
                                                    itemName: orderData['orderDateTime'],
                                                    orderName: selectedFuelType,
                                                    Orderquantity: "${orderData['requestedLiters']}L",
                                                    selectDate: orderData['selectDate'] ?? '',
                                                ),
                                              );
                                              ;
                                            },
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              childAspectRatio: 1.0,
                                              crossAxisSpacing: 20.0,
                                              mainAxisSpacing: 10,
                                              mainAxisExtent:
                                                  relativeHeight * 150,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: relativeHeight * 40.0,
                                  left: relativeWidth * 120.0,
                                  right: relativeWidth * 120.0,
                                ),
                                child: Center(
                                  child: ButtonWidget(
                                    onPressed: () {
                                      AuthService().signOut();
                                      Navigator.of(context).pushReplacement(
                                        createRoute(const LoginScreen(),
                                            TransitionType.upToDown),
                                      );
                                    },
                                    minHeight: relativeHeight * 60,
                                    buttonName: 'Logout',
                                    tcolor: Colors.white,
                                    bcolor: const Color(0xFF154478),
                                    borderColor: Colors.white,
                                    radius: 15,
                                    fcolor: Colors.grey,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
