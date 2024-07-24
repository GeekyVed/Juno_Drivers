import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:juno_drivers/global.dart';
import 'package:juno_drivers/widgets/auth_screen_img.dart';
import 'package:juno_drivers/widgets/car_info_dropdown.dart';
import 'package:juno_drivers/widgets/car_info_input.dart';

class CarInfoScreen extends StatefulWidget {
  CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  String? carModel;
  String? carNumber;
  String? carColor;
  String? selectedCarType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> carTypes = ["Car", "CNG", "Bike"];

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
      Map<String, String> driverCarInfoMap = {
        "carModel": carModel!,
        "carNumber": carNumber!,
        "carColor": carColor!,
        "selectedCarType": selectedCarType!,
      };

      // Firebase Stuff
      DatabaseReference userRef = firebaseDatabase.ref().child('drivers');
      userRef
          .child(firebaseAuth.currentUser!.uid)
          .child("car_details")
          .set(driverCarInfoMap);

      await Fluttertoast.showToast(
          msg: "Vehicle Registered Successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Get.toNamed('/home');
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
                  "A D D  C A R  D E T A I L S",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      CarInfoInput(
                        label: "Car Model",
                        onSave: (val) {
                          carModel = val;
                        },
                      ),
                      CarInfoInput(
                        label: "Car Color",
                        onSave: (val) {
                          carColor = val;
                        },
                      ),
                      CarInfoInput(
                        label: "Car Number",
                        onSave: (val) {
                          carNumber = val;
                        },
                      ),
                      CarTypeDropdownFormField(
                          label: "Please Choose ar Type",
                          carTypes: carTypes,
                          onSaved: (value) {
                            selectedCarType = value;
                          }),
                      SizedBox(
                        height: deviceHeight * 0.13,
                      ),
                      ElevatedButton(
                        onPressed: saveFormData,
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Confirm",
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
