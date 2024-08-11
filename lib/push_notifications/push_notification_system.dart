import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:juno_drivers/global.dart';
import 'package:juno_drivers/models/user_ride_request_information.dart';
import 'package:juno_drivers/push_notifications/notification_dialog_box.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    // 1. Terminated
    // When the app is closed and opened directly through the notificaiton
    messaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readUserRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });

    //2. Foreground
    // When the app is open and notif is recieved
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });

    //3. Background
    //  When the app is in the background and opened directly through the notificaiton
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });
  }

  void readUserRideRequestInformation(String userRideRequestId, context) {
    firebaseDatabase
        .ref()
        .child("All Ride Requests")
        .child(userRideRequestId)
        .child("driverId")
        .onValue
        .listen((event) {
      if (event.snapshot.value == "waiting" ||
          event.snapshot.value == firebaseAuth.currentUser!.uid) {
        firebaseDatabase
            .ref()
            .child("All Ride Requests")
            .child(userRideRequestId)
            .once()
            .then((snapData) {
          if (snapData.snapshot.value != null) {
            audioPlayer.open(Audio("lib/assets/music/music_notification.mp3"));
            audioPlayer.play();

            double originLat = double.parse(
                (snapData.snapshot.value! as Map)['origin']['latitude']);
            double originLng = double.parse(
                (snapData.snapshot.value! as Map)['origin']['longitude']);
            String originAddress =
                (snapData.snapshot.value! as Map)['originAddress'];

            double destinationLat = double.parse(
                (snapData.snapshot.value! as Map)['destination']['latitude']);
            double destinationLng = double.parse(
                (snapData.snapshot.value! as Map)['destination']['longitude']);
            String destinationAddress =
                (snapData.snapshot.value! as Map)['destinationAddress'];

            String userName = (snapData.snapshot.value! as Map)['userName'];
            String userPhone = (snapData.snapshot.value! as Map)['userPhone'];

            String? rideRequestId = snapData.snapshot.key;

            UserRideRequestInformation userRideRequestDetails =
                UserRideRequestInformation(
              originLatLng: LatLng(originLat, originLng),
              originAddress: originAddress,
              destinationLatLng: LatLng(destinationLat, destinationLng),
              destinationAddress: destinationAddress,
              userName: userName,
              userPhone: userPhone,
              rideRequestId: rideRequestId,
            );

            Get.dialog(NotificationDialogBox(
              userRideRequestDetails: userRideRequestDetails,
            ));
          } else {
            Fluttertoast.showToast(
              msg: "This Ride Request id does not exist!",
              backgroundColor: Colors.red,
              fontSize: 16,
            );
          }
        });
      } else {
        Fluttertoast.showToast(
          msg: "This Ride Request has been cancelled!",
          backgroundColor: Colors.red,
          fontSize: 16,
        );
        Get.back();
      }
    });
  }

  void generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM REGISTERATION TOKEN : $registrationToken");

    firebaseDatabase
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("token")
        .set(registrationToken);
    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
