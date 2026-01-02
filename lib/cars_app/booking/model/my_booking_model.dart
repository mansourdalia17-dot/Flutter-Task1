import 'package:studio_project/cars_app/cars/model/car_model.dart';
import 'package:studio_project/cars_app/cars_login/model/signup_model.dart';

import 'package:studio_project/cars_app/cars_login/model/user_model.dart';



class MyBooking {
  int? id;
  String? userId;
  UserModel? user;
  int? carId;
  CarModel? car;
  String? pickUpLocation;
  String? dropOffLocation;
  String? pickUpDate;
  String? dropOffDate;

  MyBooking({
    this.id,
    this.userId,
    this.user,
    this.carId,
    this.car,
    this.pickUpLocation,
    this.dropOffLocation,
    this.pickUpDate,
    this.dropOffDate,
  });

  MyBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    carId = json['carId'];
    car = json['car'] != null ? CarModel.fromJson(json['car']) : null;
    pickUpLocation = json['pickUpLocation'];
    dropOffLocation = json['dropOffLocation'];
    pickUpDate = json['pickUpDate'];
    dropOffDate = json['dropOffDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['user'] = user?.toJson();
    data['carId'] = carId;
    data['car'] = car?.toJson();
    data['pickUpLocation'] = pickUpLocation;
    data['dropOffLocation'] = dropOffLocation;
    data['pickUpDate'] = pickUpDate;
    data['dropOffDate'] = dropOffDate;
    return data;
  }
}
