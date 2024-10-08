import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:juno_drivers/models/driver_data.dart';
import 'package:juno_drivers/models/user_model.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
User? currentUser;

AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

UserModel? userModelCurrentInfo;

Position? driverCurrentPosition;

DriverData onlineDriverData = DriverData();

String driverVehicleType = "";