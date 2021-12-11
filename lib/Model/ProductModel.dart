// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

class ProductModel {
  String? uid;
  String? description;
  String? second_description;
  String? third_description;
  String? upc;
  String? itemCode;
  double? cost;
  double? price;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;

  List<String>? itemCodeList;
  List<String>? upcList;

  ProductModel.map(Map<String, dynamic> map) {
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

  ProductModel() {

  }


}