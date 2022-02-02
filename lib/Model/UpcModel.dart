// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';

class UpcModel {
  String? id;
  String? ItemDescription;
  String? productUid;
  String? locationUid;
  String? upc;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;

  UpcModel.map(Map<String, dynamic> map) {
    id = map["Id"];
    ItemDescription = map["ItemDescription"];
    productUid = map["ProductUid"];
    locationUid = map["LocationUid"];
    updated_datetime = map["UpdatedDateTime"];
    added_datetime = map["AddedDateTime"];
    updated_by = map["UpdatedBy"];
    added_by = map["AddedBy"];
    upc = map["Upc"];
  }


  DiscountModel() {

  }


}