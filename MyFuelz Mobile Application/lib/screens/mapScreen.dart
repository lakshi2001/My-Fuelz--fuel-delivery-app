import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:myfuelz/components/common/backbutton.dart';
import 'package:myfuelz/components/common/button.dart';
import 'package:myfuelz/components/common/default_text.dart';
import 'package:myfuelz/globle/constants.dart';
import 'package:myfuelz/globle/page_transition.dart';
import 'package:myfuelz/screens/detailsScreen.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import '../globle/staus/error.dart';
import '../store/application_state.dart';
import '../store/userDetails/userDetails_action.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;

  final Location location = Location();
  Set<Marker> _markers = {};
  String state = '';
  String area = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String? selectedMarkerId;
  Map<String, dynamic> selectedFuelStation = {};

  List<Map<String, dynamic>> fuelStations = [];

  @override
  void initState() {
    super.initState();
    fuelStations = StoreProvider.of<ApplicationState>(
      context,
      listen: false,
    ).state.userDetailsState.allStations;
    addMarkers();
    _getCurrentLocation();
  }

  Future<void> addMarkers() async {
    for (int i = 0; i < fuelStations.length; i++) {
      final fuelStation = fuelStations[i];
      final LatLng latLng = await _getLatLngFromAddress(fuelStation['address']);
      print('LatLng for station $i: $latLng');

      final marker = await _createMarker('fuel_$i', latLng);
      print('Marker for station $i: $marker');

      setState(() {
        _markers.add(marker);
      });

      // If this marker is selected, update selectedFuelStation
      if (selectedMarkerId == 'fuel_$i') {
        setState(() {
          selectedFuelStation = fuelStation;
          log('hdshdfggfgfgfhfhfh ${selectedFuelStation['address'].runtimeType}');
        });
      }
    }
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(address);

      if (locations.isNotEmpty) {
        geocoding.Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;
        return LatLng(latitude, longitude);
      }
    } catch (e) {
      print('Error getting LatLng from address: $e');
    }

    return LatLng(0.0, 0.0); // Return a default LatLng if an error occurs
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Marker> _createMarker(
    String markerId,
    LatLng position,
  ) async {
    final Uint8List customMarker = await getBytesFromAsset(
      path: 'assets/pin (1).png',
      width: 80,
    );

    final Uint8List selectedMarker = await getBytesFromAsset(
      path: 'assets/pin (2).png',
      width: 80,
    );

    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      icon: selectedMarkerId == markerId
          ? BitmapDescriptor.fromBytes(selectedMarker)
          : BitmapDescriptor.fromBytes(customMarker),
      onTap: () {
        setState(() {
          selectedMarkerId = markerId;
          // log('selcteddd $markerId');
          addMarkers();

          selectedFuelStation = fuelStations.firstWhere(
            (station) => station['uid'] == markerId,
            orElse: () => Map<String, dynamic>.from({
              'uid': '',
              'address': '',
              'desc': '',
              'fuelLit': 0,
              'stationName': '',
            }),
          );
        });
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final LocationData currentLocation = await location.getLocation();
      final LatLng userLocation = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      final Uint8List currMarker = await getBytesFromAsset(
        path: 'assets/pin (3).png',
        width: 80,
      );
      setState(() {
        Marker markerCurrent = Marker(
          markerId: const MarkerId('user_location'),
          position: userLocation,
          icon: BitmapDescriptor.fromBytes(currMarker),
          onTap: () {},
        );
        _markers.add(markerCurrent);
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: userLocation,
              zoom: 10,
            ),
          ),
        );
      });
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double relativeWidth = size.width / Constants.referenceWidth;
    double relativeHeight = size.height / Constants.referenceHeight;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(6.927079, 79.861244),
                zoom: 10,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
            ),
            Positioned(
              top: relativeHeight * 20.0,
              right: relativeWidth * 30.0,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                child: const Icon(Icons.my_location),
              ),
            ),
            Positioned(
                top: relativeHeight * 20.0,
                left: relativeWidth * 30.0,
                child: BackButtonWidget()),
            Positioned(
              bottom: relativeHeight * 20.0,
              left: relativeWidth * 20.0,
              right: relativeWidth * 20.0,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on), // Add location icon
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: DefaultText(
                              colorR: Color(0xFF22242E),
                              content: selectedFuelStation.isNotEmpty == true
                                  ? selectedFuelStation['address']
                                  : 'Please select a fuel station',
                              fontSizeR: 16,
                              fontWeightR: FontWeight.w400,
                              textAlignR: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: relativeWidth * 80,
                          bottom: relativeHeight * 20,
                          top: relativeHeight * 10,
                          left: relativeWidth * 80),
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonWidget(
                          onPressed: () {
                            StoreProvider.of<ApplicationState>(
                              context,
                              listen: false,
                            ).dispatch(
                              FuelDetails(
                                address: selectedFuelStation['address'],
                                fuelLit: selectedFuelStation['fuelLit'],
                                stationName: selectedFuelStation['stationName'],
                                desc: selectedFuelStation['desc'],
                                statID: selectedFuelStation['uid'],
                              ),
                            );
                            selectedFuelStation.isNotEmpty
                                ? Navigator.of(context).push(
                                    createRoute(DetailsScreen(
                                      tankerid: selectedFuelStation['uid'],
                                    ),
                                        TransitionType.upToDown),
                                  )
                                : showErrorDialog(
                                    context, 'Please select a fuel station');
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
