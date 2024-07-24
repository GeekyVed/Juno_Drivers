import 'package:firebase_database/firebase_database.dart';

class DriverData {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? imageurl;
  String? carColor;
  String? carModel;
  String? carNumber;
  String? vehicleType;

  DriverData({
    this.id,
    this.email,
    this.name,
    this.address,
    this.phone,
    this.imageurl,
    this.carColor,
    this.carModel,
    this.carNumber,
    this.vehicleType,
  });

  DriverData.fromSnapshot(DataSnapshot snapshot) {
    id = (snapshot.value as dynamic)['id'];
    name = (snapshot.value as dynamic)['name'];
    email = (snapshot.value as dynamic)['email'];
    address = (snapshot.value as dynamic)['address'];
    phone = (snapshot.value as dynamic)['phone'];
    imageurl = (snapshot.value as dynamic)['imageurl'];
    carModel = (snapshot.value as dynamic)['car_details']['carModel'];
    carNumber = (snapshot.value as dynamic)['car_details']['carNumber'];
    carColor = (snapshot.value as dynamic)['car_details']['carColor'];
    vehicleType = (snapshot.value as dynamic)['car_details']['selectedCarType'];
  }

   void printAll() {
    print('Driver Information:');
    print('ID: $id');
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Address: $address');
    print('Image URL: $imageurl');
    print('Car Details:');
    print('  Model: $carModel');
    print('  Number: $carNumber');
    print('  Color: $carColor');
    print('  Type: $vehicleType');
  }
}
