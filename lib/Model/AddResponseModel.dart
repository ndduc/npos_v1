import 'package:npos/Debug/Debug.dart';

class AddResponseModel {
  String? Product_Location_Status;
  String? Product_Department;
  String? Product_Category;
  String? Product_Vendor;
  String? Product_Section;
  String? Product_Tax;
  String? Product_Discount;
  String? Product_ItemCode;
  String? Product_Upc;

  AddResponseModel(){}

  AddResponseModel.map(Map<String, dynamic> map) {
    Product_Location_Status = map["Product_Location_Status"];
    Product_Department = map["Product_Department"];
    Product_Category = map["Product_Category"];
    Product_Vendor = map["Product_Vendor"];
    Product_Section = map["Product_Section"];
    Product_Tax = map["Product_Tax"];
    Product_Discount = map["Product_Discount"];
    Product_ItemCode = map["Product_ItemCode"];
    Product_Upc = map["Product_Upc"];
  }

  print() {
    ConsolePrint("Product_Location_Status", Product_Location_Status);
    ConsolePrint("Product_Department", Product_Department);
    ConsolePrint("Product_Category", Product_Category);
    ConsolePrint("Product_Vendor", Product_Vendor);
    ConsolePrint("Product_Section", Product_Section);
    ConsolePrint("Product_Section", Product_Section);
    ConsolePrint("Product_Tax", Product_Tax);
    ConsolePrint("Product_Discount", Product_Discount);
    ConsolePrint("Product_ItemCode", Product_ItemCode);
    ConsolePrint("Product_Upc", Product_Upc);
  }

}