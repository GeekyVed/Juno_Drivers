import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:juno_drivers/assistants/assistant_methods.dart';
import 'package:juno_drivers/global.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // var geolocator = Geolocator();
  // LocationPermission? _locationPermission;
  String status = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  void locateDriverPosition() async {
    // this method locats our posiotn and puts in center of map and also reverse geocode thename of place

    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition newCameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 13,
    );
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));

    // rEVERSE gEOcodeing
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicalCordinates_Position(
            driverCurrentPosition!, context);
  }

  void checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: "Error Occured : Location services are disabled.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Error Occured : Location permissions are denied.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              "Error Occured : Location permissions are permanently denied, we cannot request permissions.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    AssistantMethods.readCurrentDriverInformation();
    locateDriverPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 40),
          mapType: MapType.normal,
          myLocationEnabled: true, // Show the small dot for current location
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);

            newGoogleMapController = controller;

            setState(() {});

            // Fetching user curent locaiotn to show taht
            locateDriverPosition();
          },
          initialCameraPosition: _kGooglePlex,
        ),
        //UI for Driver Status
        status != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black87,
              )
            : Container(),

        //Button For change in Status
        SafeArea(
          child: Align(
            alignment:
                status == "Now Online" ? Alignment.topCenter : Alignment.center,
            child: Padding(
              padding: status == "Now Online"
                  ? const EdgeInsets.only(top: 10.0)
                  : EdgeInsets.zero,
              child: ElevatedButton(
                onPressed: () {
                  if (!isDriverActive) {
                    driverOnlineNow();
                    updateDriverLocationAtRealTime();
                    setState(() {
                      status = "Now Online";
                      isDriverActive = true;
                      buttonColor = Colors.transparent;
                    });
                    Fluttertoast.showToast(
                      msg: "You are Online Now!",
                      fontSize: 16,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    driverIsOfflineNow();
                    setState(() {
                      status = "Now Offline";
                      isDriverActive = false;
                      buttonColor = Colors.grey;
                    });
                    Fluttertoast.showToast(
                      msg: "You are Offline Now!",
                      fontSize: 16,
                      backgroundColor: Colors.red,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: status == "Now Online"
                      ? Size(
                          MediaQuery.of(context).size.width * 0.3,
                          60,
                        )
                      : Size(
                          MediaQuery.of(context).size.width * 0.7,
                          60,
                        ),
                ),
                child: status != "Now Online"
                    ? Text(
                        status,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    : const Icon(
                        Icons.phonelink_ring,
                        color: Colors.red,
                        size: 26,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void driverIsOfflineNow() async {
    Geofire.removeLocation(
      firebaseAuth.currentUser!.uid,
    );
    DatabaseReference? ref = firebaseDatabase
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(Duration(milliseconds: 2000), () {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }

  void driverOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
      firebaseAuth.currentUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    DatabaseReference ref = firebaseDatabase
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .child("newRideStatus");
    ref.set('idle');
    ref.onValue.listen((event) {});
  }

  void updateDriverLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive == true) {
        Geofire.setLocation(
          firebaseAuth.currentUser!.uid,
          driverCurrentPosition!.latitude,
          driverCurrentPosition!.longitude,
        );
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
