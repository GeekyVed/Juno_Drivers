import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juno_drivers/assistants/assistant_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration splashTime = Duration(
    milliseconds: 2750,
  );

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FutureOr getNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first-checkin') == true ||
        prefs.getBool('first-checkin') == null) {
      Get.offNamed("/onboarding");
    } else if (prefs.getBool('logged-in') == true) {
      Get.offNamed("/home");
    } else {
      Get.offNamed("/login");
    }
  }

  void fetchuserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('logged-in') == true) {
      AssistantMethods.readCurrentOnlineUserInfo();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchuserData();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(SplashScreen.splashTime, getNextScreen);

    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.28,
            ),
            Text(
              "Juno",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "Drivers",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 100),
            ),
            SizedBox(
              height: deviceHeight * 0.3,
            ),
            Text(
              "Connect. Move. Save.",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
