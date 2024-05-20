import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/order/orderCard.dart';
import 'package:myfuelz/components/order/ordersummary.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/store/userDetails/userDetails_action.dart';
import '../components/common/backbutton.dart';
import '../components/common/progess_bar.dart';
import '../models/user_model.dart';
import '../store/application_state.dart';
import '../store/userDetails/userDetails_state.dart';

class OrderDetailsScreen extends StatefulWidget {
  final double requestFuel;
  final String selectDate;
  const OrderDetailsScreen({
    super.key,
    required this.requestFuel,
    required this.selectDate
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isLoading = true;
  double progressValue = 0.0;
  Map<String, dynamic> currentTanker = {};
  Map<String, dynamic> token = {};
  final UserModel _userModel = UserModel();

  @override
  void initState() {
    super.initState();
    var tankerId = StoreProvider.of<ApplicationState>(
      context,
      listen: false,
    ).state.userDetailsState.selectedStatID;
    _userModel.getUser(tankerId).then((featuredUserList) {
      setState(() {
        progressValue = 0.5;
        currentTanker = featuredUserList;
        // log('curnrtttttt ${currentTanker}');
        StoreProvider.of<ApplicationState>(
          context,
          listen: false,
        ).dispatch(
          TankerDetails(
            email: currentTanker['email'],
            name: currentTanker['name'],
            phoneNumber: currentTanker['phone'],
            role: currentTanker['role'],
            userID: currentTanker['uid'],
          ),
        );
        progressValue = 0.7;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      Center(
        child: Text(
          "We are facing internal issue: ${error.toString()}",
          style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      );
    });
    _userModel.getToken(tankerId).then((featuredUserList) {
      setState(() {
        token = featuredUserList;
        log('tokennn ${token}');

        progressValue = 0.9;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      Center(
        child: Text(
          "We are facing internal issue: ${error.toString()}",
          style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      );
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
                  : CustomScrollView(slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
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
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: relativeHeight * 40.0,
                                    left: relativeWidth * 30.0,
                                    right: relativeWidth * 30.0,
                                  ),
                                  child: Expanded(

                                    child: OrderCard(
                                      imageurl: 'assets/fuel.png',
                                      orderName: state.selectedStationName,
                                      Orderquantity: '${widget.requestFuel} Liters',
                                      itemName: 'Fuel',
                                      selectDate: widget.selectDate,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      top: relativeHeight * 50.0,
                                      left: relativeWidth * 30.0,
                                      right: relativeWidth * 30),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: DefaultText(
                                              colorR: Colors.grey,
                                              content: 'Order Location',
                                              fontSizeR: 16,
                                              fontWeightR: FontWeight.w400,
                                              textAlignR: TextAlign.start,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child:
                                                      Icon(Icons.location_on),
                                                ), // Add location icon
                                                const SizedBox(width: 8.0),
                                                Expanded(
                                                  child: DefaultText(
                                                    colorR:
                                                        const Color(0xFF22242E),
                                                    content: state.selectedAdd,
                                                    fontSizeR: 16,
                                                    fontWeightR:
                                                        FontWeight.w400,
                                                    textAlignR: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: relativeHeight * 50.0,
                                      left: relativeWidth * 30.0,
                                      right: relativeWidth * 30),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF154478),
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ViewOrderSummary(
                                      itemCount: widget.requestFuel,
                                      totalprice: (widget.requestFuel * 37).toString(),
                                      token: token['token'],
                                        selectDate: widget.selectDate,
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                      ),
                    ]))),
    );
  }
}
