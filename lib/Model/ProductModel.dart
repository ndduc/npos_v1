// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';

class ProductModel {
  String? uid;
  String? description;
  String? second_description;
  String? third_description;
  int? upc;
  int? itemCode;
  double? cost;
  double? price;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;

  List<String>? itemCodeList;
  List<String>? upcList;

  ProductModel.map(Map<String, dynamic> map) {
    ConsolePrint("MAP MODEL", map);
    uid = map["UId"];
    description = map["Description"];
    second_description = map["SecondDescription"];
    third_description = map["ThirdDescription"];
    upc = map["Upc"];
    itemCode = map["ItemCode"];
    cost = map["Cost"].toDouble();
    price = map["Price"].toDouble();
    updated_datetime = map["UpdatedDateTime"];
    added_datetime = map["AddedDateTime"];
    updated_by = map["UpdatedBy"];
    added_by = map["AddedBy"];
    itemCodeList = (map["ItemCodeList"] as List).map((item) => item as String).toList();
  }

  void print() {
    ConsolePrint("uid", uid);
    ConsolePrint("description", description);
    ConsolePrint("second_description", second_description);
    ConsolePrint("third_description", third_description);
    ConsolePrint("upc", upc);
    ConsolePrint("itemCode", itemCode);
    ConsolePrint("cost", cost);
    ConsolePrint("price", price);
    ConsolePrint("updated_datetime", updated_datetime);
    ConsolePrint("added_datetime", added_datetime);
    ConsolePrint("updated_by", updated_by);
    ConsolePrint("added_by", added_by);
    ConsolePrint("itemCodeList", itemCodeList);
  }

  ProductModel() {

  }


}