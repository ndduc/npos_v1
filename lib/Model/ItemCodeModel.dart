// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';

class ItemCodeModel {
  String? id;
  String? ItemDescription;
  String? productUid;
  String? locationUid;
  String? itemCode;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;

  ItemCodeModel.map(Map<String, dynamic> map) {
    id = map["Id"];
    ItemDescription = map["ItemDescription"];
    productUid = map["ProductUid"];
    locationUid = map["LocationUid"];
    updated_datetime = map["UpdatedDateTime"];
    added_datetime = map["AddedDateTime"];
    updated_by = map["UpdatedBy"];
    added_by = map["AddedBy"];
  }


  DiscountModel() {

  }


}