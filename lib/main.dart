import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:juno_drivers/firebase_options.dart';
import 'package:juno_drivers/screens/car_info.dart';
import 'package:juno_drivers/screens/forgot_password.dart';
import 'package:juno_drivers/screens/home.dart';
import 'package:juno_drivers/screens/login.dart';
import 'package:juno_drivers/screens/onboarding.dart';
import 'package:juno_drivers/screens/profile.dart';
import 'package:juno_drivers/screens/register.dart';
import 'package:juno_drivers/screens/splash.dart';
import 'package:juno_drivers/themes/dark.dart';
import 'package:juno_drivers/themes/light.dart';
import 'package:juno_drivers/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await registerControllers();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Juno - Driver',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/profile': (context) => ProfileScreen(),
        '/carInfo': (context) => CarInfoScreen(),
      },
      initialRoute: '/splash',
    );
  }
}
