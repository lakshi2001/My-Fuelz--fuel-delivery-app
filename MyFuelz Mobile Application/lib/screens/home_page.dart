import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/components/home/elementCard.dart';
import 'package:myfuelz/globle/staus/connection.dart';
import 'package:myfuelz/models/fuel_model.dart';
import 'package:myfuelz/screens/mapScreen.dart';
import '../components/common/progess_bar.dart';
import '../components/feedbacks/show_aproved_feedbacks.dart';
import '../components/home/banner.dart';
import '../globle/constants.dart';
import '../globle/page_transition.dart';
import '../store/application_state.dart';
import '../store/userDetails/userDetails_action.dart';
import 'budget_calculator.dart';
import 'notifications.dart';

class HomePage extends StatefulWidget {
  final Function(bool) onLoadingStateChanged;

  const HomePage({super.key, required this.onLoadingStateChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> elementCardData = [
    {
      'name': 'Fuel',
      'time': '',
      'imageurl': 'assets/fuel.png',
    },

  ];

  var isLoading = true;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool showedDialog = false;
  double progressValue = 0.0;
  List<Map<String, dynamic>> fuelAdd = [];
  final FuelModel _fuelModel = FuelModel();

  // for get user photo and name
  late DatabaseReference _userRef;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _userRef = FirebaseDatabase.instance.reference().child("users").child(_currentUser.uid);
    _fetchFuelData();
    _fetchUserData();
  }

// for get user photo and name
  Future<void> _fetchUserData() async {
    _userRef = FirebaseDatabase.instance.reference().child("users").child(_currentUser.uid);
  }

  Future<void> _fetchFuelData() async {
    try {
      fuelAdd = await _fuelModel.getAllTankers();

      setState(() {
        log('address ${fuelAdd}');
        for (int i = 0; i < fuelAdd.length; i++) {

          log('fuel $i : ${fuelAdd[i]}');
          StoreProvider.of<ApplicationState>(
            context,
            listen: false,
          ).dispatch(FuelStations(stations: fuelAdd));
        }
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
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(90.0),
              child: AppBar(
                backgroundColor: Colors.blue.shade900,
                title: FutureBuilder<DatabaseEvent>(
                  future: _userRef.once(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // get dataSnapshot from the DatabaseEvent
                      DataSnapshot userDataSnapshot = snapshot.data!.snapshot;
                      Map<dynamic, dynamic> userData = userDataSnapshot.value as Map<dynamic, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(userData['imageURL'] ?? ''),
                                ),
                                const SizedBox(width: 18),
                                Text(
                                  userData['name'] ?? '',
                                  style: const TextStyle(fontSize: 22, color: Colors.white),
                                ),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage() ));
                                  },
                                  child: Icon(Icons.notifications_active,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )

                      );
                    }
                  },
                ),
              ),
            ),
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
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DefaultText(
                                            colorR: Color(0xFF22242E),
                                            content: 'No More Hassle',
                                            fontSizeR: 32,
                                            fontWeightR: FontWeight.w800,
                                            textAlignR: TextAlign.start,
                                          ),
                                          DefaultText(
                                            colorR: Color(0xFF22242E),
                                            content:
                                                'Find Your Place for All Your Car Needs',
                                            fontSizeR: 25,
                                            fontWeightR: FontWeight.w400,
                                            textAlignR: TextAlign.start,
                                          ),
                                        ],
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
                                    //       print('objectttttttttt');
                                    //       AuthService().signOut();
                                    //       Navigator.of(context).pushReplacement(
                                    //         createRoute(const LoginScreen(),
                                    //             TransitionType.upToDown),
                                    //       );
                                    //     },
                                    //     color: Colors.blue,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),

                              Banners(),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: relativeWidth * 20,
                                  top: relativeHeight * 40,
                                  right: relativeWidth * 20,
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
                                            itemCount: elementCardData.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  print("object");
                                                  index == 0
                                                      ? Navigator.of(context)
                                                          .push(
                                                          createRoute(
                                                              const MapPage(),
                                                              TransitionType
                                                                  .upToDown),
                                                        )
                                                      : null;
                                                },
                                                child: ElementCard(
                                                  name: elementCardData[index]
                                                          ['name'] ??
                                                      '',
                                                  time: elementCardData[index]
                                                          ['time'] ??
                                                      '',
                                                  imageurl:
                                                      elementCardData[index]
                                                              ['imageurl'] ??
                                                          '',
                                                ),
                                              );
                                            },
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1.0,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20,
                                              mainAxisExtent: 160,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 15,),


                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BudgetCalculatePage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF154478).withOpacity(0.4),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Color(0xFF154478),),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.calculate, color: Color(0xFF154478), size: 27,),
                                                  SizedBox(width: 5,),
                                                  Text(
                                                    'Calculate Budget',
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.arrow_forward, size: 25,)
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            ' ',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 15,),

                              Container(

                                color: Colors.blue.shade50,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Users Feedbacks',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF154478),
                                        ),
                                      ),
                                    ),

                                    ApprovedFeedbackPage(),
                                  ],
                                ),

                              ),




                            ]),
                      ]),
                    )
                  ])));
  }
}
