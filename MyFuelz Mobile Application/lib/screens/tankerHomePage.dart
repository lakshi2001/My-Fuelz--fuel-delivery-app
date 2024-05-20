import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/common/novalidateTextField.dart';
import 'package:myfuelz/components/common/text_feild.dart';
import 'package:myfuelz/components/home/elementCard.dart';
import 'package:myfuelz/globle/staus/connection.dart';
import 'package:myfuelz/screens/login.dart';
import 'package:myfuelz/services/fuel_service.dart';
import '../components/common/progess_bar.dart';
import '../globle/constants.dart';
import '../globle/page_transition.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../store/application_state.dart';
import '../store/userDetails/userDetails_action.dart';
import '../store/userDetails/userDetails_state.dart';
import 'notifications.dart';

class TankerHomePage extends StatefulWidget {
  final Function(bool) onLoadingStateChanged;

  const TankerHomePage({super.key, required this.onLoadingStateChanged});

  @override
  State<TankerHomePage> createState() => _TankerHomePageState();
}

class _TankerHomePageState extends State<TankerHomePage> {
  List<Map<String, String>> elementCardData = [
    {
      'name': 'Fuel',
      'time': '',
      'imageurl': 'assets/Restaurant Image.png',
    },
    {
      'name': 'Car Wash',
      'time': '',
      'imageurl': 'assets/car wash.png',
    },
    {
      'name': 'Battery',
      'time': '12 mins',
      'imageurl': 'assets/battery.png',
    },
    {
      'name': 'Smart Resto',
      'time': '18 mins',
      'imageurl': 'assets/smart.png',
    },
    {
      'name': 'Vegan Resto',
      'time': '12 mins',
      'imageurl': 'assets/vegan.png',
    },
    {
      'name': 'Healthy Food',
      'time': '8 mins',
      'imageurl': 'assets/healthy.png',
    },
    // Add more data as needed
  ];
  static String? uid;
  var currentUser = <dynamic>[];
  var isLoading = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var featuredWeekRecipies = <dynamic>[];
  late bool isDark;
  String? mtoken = '';
  bool isShowRecipes = false;
  // List featuredToken = <dynamic>[];
  // int tokenCount = 0;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  Map<dynamic, dynamic> confi = {};
  late Timer _timer;
  Duration _duration = Duration.zero;
  late DateTime startDate;
  late DateTime endDate;
  int maxOrderCount = 0;
  int currentOrderCount = 0;
  int initLevel = 0;
  var address = <dynamic>[];
  bool showedDialog = false;
  late TextEditingController _numberController = TextEditingController();
  final FuelService _fuelService = FuelService();
  double progressValue = 0.0;

  late String selectedFuelType;

  @override
  void initState() {
    setState(() {
      _numberController = TextEditingController(
          text: StoreProvider.of<ApplicationState>(
        context,
        listen: false,
      ).state.userDetailsState.selectedFuelLit);
      progressValue = 1.0;
      isLoading = false;
    });
    selectedFuelType = Random().nextBool() ? 'Petrol' : 'Diesel';

    // log('tokennn ${StoreProvider.of<ApplicationState>(
    //   context,
    //   listen: false,
    // ).state.userDetailsState.selectedEmail}');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getConnectivity();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        // ignore: use_build_context_synchronously
        showConnetionDialog(
          context,
          isDeviceConnected,
          isAlertSet,
        );
        setState(() {
          isAlertSet = true;
        });
      } else {
        setState(() {
          isAlertSet = false;
        });
      }
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
                                      top: relativeHeight * 40.0,
                                      left: relativeWidth * 30.0,
                                      right: relativeWidth * 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: DefaultText(
                                          colorR: Color(0xFF22242E),
                                          content: state.selectedStationName,
                                          fontSizeR: 35,
                                          fontWeightR: FontWeight.w400,
                                          textAlignR: TextAlign.start,
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage() ));
                                        },
                                        child: Icon(Icons.notifications_active,
                                          color: Colors.black54,
                                          size: 34,
                                        ),
                                      ),

                                      // SizedBox(
                                      //   width: relativeWidth * 30,
                                      // ),
                                      // Container(
                                      //   width: relativeWidth * 80.0,
                                      //   height: relativeHeight * 80.0,
                                      //   decoration: const BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     color: Colors.white,
                                      //   ),
                                      //   child: IconButton(
                                      //     icon: const Icon(
                                      //       Icons.notifications_active_outlined,
                                      //       size: 30,
                                      //     ),
                                      //     onPressed: () {
                                      //       //             _notificationServices.sendPushMessage(
                                      //       // 'Order placed Succesfully', 'New order');

                                      //     },
                                      //     color: Colors.blue,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
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
                                    time: state.selectedFuelLit,
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
                                    content: 'Left Litters',
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
                                    child: NoValidateCustomTextField(
                                      controller: _numberController,
                                      hintText: 'Number of Litters Left',
                                    ),
                                  )),
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
                                        _fuelService.updateFuelLit(
                                            _numberController.text,
                                            state.selectedUserId);
                                        setState(() {
                                          StoreProvider.of<ApplicationState>(
                                            context,
                                            listen: false,
                                          ).dispatch(
                                            FuelDetails(
                                              address: state.selectedAdd,
                                              fuelLit: _numberController.text,
                                              stationName:
                                                  state.selectedStationName,
                                              desc: state.selectedDesc,
                                              statID: state.selectedStatID,
                                            ),
                                          );
                                        });
                                      },
                                      minHeight: relativeHeight * 60,
                                      buttonName: 'Update',
                                      tcolor: Colors.white,
                                      bcolor: const Color(0xFF154478),
                                      borderColor: Colors.white,
                                      radius: 15,
                                      fcolor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                      )
                    ]))),
    );
  }
}
