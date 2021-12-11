// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'LocationModel.dart';

List<UserModel> userFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));


//String albumsToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    required this.uid,
    required this.userName,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.email2,
    this.phone,
    this.address,
    this.userType,
    this.addedDateTime,
    this.updatedDateTime,
    required this.isAuthorized

  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["UId"];
    userName = map["UserName"];
    firstName = map["FirstName"];
    lastName = map["LastName"];
    email = map["Email"];
    email2 = map["Email2"];
    phone = map["Phone"];
    address = map["Address"];
    addedDateTime = map["AddedDatetime"];
    updatedDateTime = map["UpdatedDatetime"];
    userType = map["UserType"];
    isAuthorized = map["IsAuthorize"];
  }

  late String uid;
  late String userName;
  late String? password;
  late String firstName;
  late String lastName;
  late String email;
  late String? email2;
  late String? phone;
  late String? address;
  late String? userType;
  late String? addedDateTime;
  late String? updatedDateTime;
  late bool isAuthorized = false;
  List<LocationModel>? locationList;
  LocationModel? defaultLocation;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uid: json["UId"],
      userName: json["UserName"],
      firstName: json["FirstName"],
      lastName: json["LastName"],
      email: json["Email"],
      email2: json["Email2"],
      phone: json["Phone"],
      address: json["Address"],
      addedDateTime: json["AddedDatetime"],
      updatedDateTime: json["UpdatedDatetime"],
      userType: json["UserType"],
      isAuthorized: json["IsAuthorize"]
  );


  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "title": title,
  // };
}