// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';

class LocationModel {
  String? uid;
  String? name;
  String? address;
  int? zipcode;
  String? state;
  String? phonenumber;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;
  late bool isError;
  String? error;
  String? relation;

  LocationModel.map(Map<String, dynamic> map) {
    uid = map["uId"];
    name = map["name"];
    address = map["address"];
    zipcode = map["zipCode"];
    state = map["state"];
    phonenumber = map["phoneNumber"];
    added_datetime = map["addedDateTime"];
    updated_datetime = map["updatedDateTime"];
    isError = map["isError"];
    error = map["error"];
    relation = map["relationReason"];
  }

  LocationModel.mapJsonStyle2(Map<String, dynamic> map) {
    uid = map["UId"];
    name = map["Name"];
    address = map["Address"];
    zipcode = map["ZipCode"];
    state = map["State"];
    phonenumber = map["PhoneNumber"];
    added_datetime = map["AddedDateTime"];
    updated_datetime = map["UpdatedDateTime"];
    isError = map["IsError"];
    error = map["Error"];
    relation = map["RelationReason"];
  }

  print() {
    ConsolePrint("Uid", uid);
    ConsolePrint("name", name);
    ConsolePrint("address", address);
    ConsolePrint("zipcode", zipcode);
  }
}