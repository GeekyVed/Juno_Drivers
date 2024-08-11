import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:juno_drivers/assistants/assistant_methods.dart';
import 'package:juno_drivers/global.dart';
import 'package:juno_drivers/models/user_ride_request_information.dart';

class NotificationDialogBox extends StatefulWidget {
  final UserRideRequestInformation? userRideRequestDetails;

  const NotificationDialogBox(
      {super.key, required this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 190, 40, 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 115,
            child: Image.asset(
              onlineDriverData.vehicleType == "Car"
                  ? "lib/assets/images/car_fare.png"
                  : onlineDriverData.vehicleType == "Bike"
                      ? "lib/assets/images/bike_fare.png"
                      : "lib/assets/images/auto_fare.png",
            ),
          ),
          SizedBox(
            height: 10,
          ),

          //title
          Text(
            "New Ride Request",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 14,
          ),
          const Divider(
            height: 2,
            thickness: 2,
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/origin.png',
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                      child: Text(
                        widget.userRideRequestDetails!.originAddress!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/destination.png',
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                      child: Text(
                        widget.userRideRequestDetails!.destinationAddress!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
            color: Colors.green,
          ),

          // Buttons for acception and cancelling the ride request
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize: WidgetStatePropertyAll(
                        Size(
                          30,
                          45,
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(Colors.red)),
                  onPressed: () {
                    audioPlayer.pause();
                    audioPlayer.stop();
                    audioPlayer = AssetsAudioPlayer();

                    Get.back();
                  },
                  child: Text(
                    "Cancel".toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        minimumSize: WidgetStatePropertyAll(
                          Size(
                            30,
                            45,
                          ),
                        ),
                      ),
                  onPressed: () {
                    audioPlayer.pause();
                    audioPlayer.stop();
                    audioPlayer = AssetsAudioPlayer();

                    acceptRideRequest(context);
                  },
                  child: Text(
                    "Accept".toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    firebaseDatabase
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snapData) {
      if (snapData.snapshot.value == "idle") {
        firebaseDatabase
            .ref()
            .child("drivers")
            .child(firebaseAuth.currentUser!.uid)
            .child("newRideStatus")
            .set("accepted");

        AssistantMethods.pauseLiveLocationUpdates();

        //Trip started now...send driver to new trip screen
        Get.toNamed('/new_trip');
      } else {
        Fluttertoast.showToast(
          msg: "This ride request does not exist",
          fontSize: 16,
          backgroundColor: Colors.red,
        );
      }
    });
  }
}
