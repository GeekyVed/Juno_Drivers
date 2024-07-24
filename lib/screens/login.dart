import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juno_drivers/global.dart';
import 'package:juno_drivers/widgets/auth_google_btn.dart';
import 'package:juno_drivers/widgets/auth_input_field.dart';
import 'package:juno_drivers/widgets/auth_screen_img.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

  String? password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  bool isLoading = false;

  void saveFormData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    setState(() {
      isLoading = true;
    });
    try {
      // Firebase Stuff
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!);

      // Changes for drivers app
      DatabaseReference userRef = firebaseDatabase.ref().child('drivers');
      userRef.child(firebaseAuth.currentUser!.uid).once().then((val) async {
        final snapshot = val.snapshot;
        if (snapshot.value != null) {
          currentUser = userCredential.user;
          await Fluttertoast.showToast(
              msg: "Login Successful",
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          // Updating Auth Status
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("logged-in", true);

          Get.toNamed('/home');
        } else {
          await Fluttertoast.showToast(
              msg: "No record exists with this email",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        firebaseAuth.signOut();
        }
      });
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error Occured : ${error}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AuthScreenImg(),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Text(
                  "L O G I N",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      AuthInputField(
                        label: "Email",
                        onSave: (val) {
                          email = val;
                        },
                      ),
                      AuthInputField(
                        label: "Password",
                        onSave: (val) {
                          password = val;
                        },
                        minLength: 8,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.025,
                      ),
                      ElevatedButton(
                        onPressed: saveFormData,
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.008,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/forgotPassword');
                        },
                        child: Text(
                          "Forgot Password!",
                          style: GoogleFonts.quicksand(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.onSurface,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(width: 6),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/register');
                            },
                            child: Text(
                              "Don't have an Account!",
                              style: GoogleFonts.quicksand(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).colorScheme.onSurface,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      AuthGoogleBtn(
                        label: "Sign In with Google",
                      ),
                      SizedBox(
                        height: deviceHeight * 0.05,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
