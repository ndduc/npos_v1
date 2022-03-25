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
  String? str_upc;
  int? itemCode;
  double? cost;
  double? price;
  String? added_datetime;
  String? updated_datetime;
  String? added_by;
  String? updated_by;
  bool isEmpty = false;  // set to true once api return empty object

  late List<String> itemCodeList;
  late List<String> categoryList;
  late List<String> departmentList;
  late List<String> sectionList;
  late List<String> vendorList;
  late List<String> discountList;
  late List<String> taxList;
  late List<String> upcList;

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

    if (map["ItemCodeList"] == null) {
      itemCodeList = [];
    }  else {
      itemCodeList = (map["ItemCodeList"] as List).map((item) => item as String).toList();
    }

    if (map["UpcList"] == null) {
      upcList = [];
    }  else {
      upcList = (map["UpcList"] as List).map((item) => item as String).toList();
    }

    if (map["CategoryList"] == null) {
      categoryList = [];
    }  else {
      // categoryList = (map["CategoryList"] as List).map((item) => item as String).toList();
      categoryList = [];
      List<dynamic> cate = map["CategoryList"];
      if (cate.isNotEmpty) {
        categoryList.add(cate[0]["UId"]);
      }

    }

    if (map["DepartmentList"] == null) {
      departmentList = [];
    }  else {
      // departmentList = (map["DepartmentList"] as List).map((item) => item as String).toList();
      departmentList = [];
      List<dynamic> dept = map["DepartmentList"];
      if (dept.isNotEmpty) {
        departmentList.add(dept[0]["UId"]);
      }

    }

    if (map["SectionList"] == null) {
      sectionList = [];
    }  else {
      // sectionList = (map["SectionList"] as List).map((item) => item as String).toList();
      sectionList = [];
      List<dynamic> sec = map["SectionList"];
      if (sec.isNotEmpty) {
        sectionList.add(sec[0]["UId"]);
      }

    }

    if (map["VendorList"] == null) {
      vendorList = [];
    }  else {
      // vendorList = (map["VendorList"] as List).map((item) => item as String).toList();
      vendorList= [];
      List<dynamic> ven = map["VendorList"];
      if(ven.isNotEmpty) {
        vendorList.add(ven[0]["UId"]);
      }

    }

    if (map["DiscountList"] == null) {
      discountList = [];
    }  else {
      //discountList = (map["DiscountList"] as List).map((item) => item as String).toList();
      discountList = [];
      List<dynamic> discount = map["DiscountList"];
      if(discount.isNotEmpty) {
        discountList.add(discount[0]["UId"]);
      }

    }

    if (map["TaxList"] == null) {
      taxList = [];
    }  else {
      taxList = [];
      List<dynamic> tax = map["TaxList"];
      if (tax.isNotEmpty) {
        taxList.add(tax[0]["UId"]);
      }
      ConsolePrint("TAX" , taxList);

    }
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
    ConsolePrint("upcList", upcList);
    ConsolePrint("departmentList", departmentList);
    ConsolePrint("categoryList", categoryList);
    ConsolePrint("sectionList", sectionList);
    ConsolePrint("vendorList", vendorList);
    ConsolePrint("discountList", discountList);
    ConsolePrint("taxList", taxList);

  }

  ProductModel() {

  }


}