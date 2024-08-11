import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:juno_drivers/global.dart';
import 'package:juno_drivers/models/user_ride_request_information.dart';
import 'package:juno_drivers/push_notifications/notification_dialog_box.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final userRideRequestInfo1 = UserRideRequestInformation(
      originLatLng: LatLng(37.7749, -122.4194), // San Francisco, CA
      destinationLatLng: LatLng(34.0522, -118.2437), // Los Angeles, CA
      originAddress: '123 Start St, San Francisco, CA 94103',
      destinationAddress: '456 End Ave, Los Angeles, CA 90001',
      rideRequestId: 'ride12345',
      userName: 'John Doe',
      userPhone: '+1-555-123-4567',
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.dialog(NotificationDialogBox(
                    userRideRequestDetails: userRideRequestInfo1));
              },
              child: Text('Open Dialog'),
            ),
            SizedBox(height: 56,),
            ElevatedButton(
              onPressed: () {
                audioPlayer.open(Audio("lib/assets/music/music_notification.mp3"));
                audioPlayer.play();
              },
              child: Text('Play Music'),
            ),
          ],
        ),
      ),
    );
  }
}
