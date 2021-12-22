// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';

class DiscountModel {
  String? uid;
  String? description;
  String? second_description;
  String? location_uid;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;
  double? rate;

  DiscountModel.map(Map<String, dynamic> map) {
    uid = map["UId"];
    description = map["Description"];
    second_description = map["SecondDescription"];
    updated_datetime = map["UpdatedDateTime"];
    added_datetime = map["AddedDateTime"];
    updated_by = map["UpdatedBy"];
    added_by = map["AddedBy"];
    rate = map["Rate"].toDouble();
  }

  void print() {
    ConsolePrint("uid", uid);
    ConsolePrint("description", description);
    ConsolePrint("second_description", second_description);
    ConsolePrint("updated_datetime", updated_datetime);
    ConsolePrint("added_datetime", added_datetime);
    ConsolePrint("updated_by", updated_by);
    ConsolePrint("added_by", added_by);
  }

  DiscountModel() {

  }


}