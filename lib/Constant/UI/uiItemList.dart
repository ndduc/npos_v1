// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:npos/Constant/UIEvent/menuEvent.dart';

List<Map<dynamic, dynamic>> menuItem = [
  {"id" : 0, "name" : "Product Management", "event" : "MENU_PRODUCT_MAN"},
  {"id" : 1, "name" : "Product Property Management", "event" : "MENU_DEPT/CATE_MAN"},
  {"id" : 2, "name" : "Section and Aisle Management", "event" : "MENU_SEC_MAN"},
  {"id" : 3, "name" : "Discount and Tax Management", "event" : "MENU_DIS/TAX_MAN"},
  {"id" : 4, "name" : "Source and Supply Management", "event" : "MENU_VEN_MAN"},
  {"id" : 5, "name" : "Employee Management\n(Not Done)", "event" : "MENU_EMP_MAN"},
  {"id" : 6, "name" : "Store/Location Management\n(To Be Implemented)", "event" : "MENU_LOC_MAN"},
  {"id" : 7, "name" : "System Setup\n(To Be Implemented)", "event":"MENU_SETUP"},

  {"id" : 8, "name" : "Inventory Report\n(To Be Implemented)", "event" : "MENU_INV_REPORT"},
  {"id" : 9, "name" : "Detail Report\n(To Be Implemented)", "event" : "MENU_DE_REPORT"},
  {"id" : 10, "name" : "Daily Report\n(To Be Implemented)", "event" : "MENU_DAI_REPORT"},
  {"id" : 11, "name" : "Analysis/Cashier Performance Report\n(To Be Implemented)", "event" : "MENU_ANA_REPORT"},
  {"id" : 12, "name" : "Customer Royalty\n(To Be Implemented)", "event" : "MENU_CUS_ROYAL"},
  {"id" : 13, "name" : "Point Management\n(To Be Implemented)", "event" : "MENU_POINT_MAN"},
  {"id" : 14, "name" : "Customer Notification\n(To Be Implemented)", "event" : "MENU_CUS_NOTI"},
  {"id" : 15, "name" : "Social Media Management\n(To Be Implemented)", "event" : "MENU_SOC_MAN"},

];

List<Map<dynamic, dynamic>> menuItemLeft = [
  {"id" : 0, "name" : "POS Client\n(Implementing)", "event" : "PC"},
  {"id" : 1, "name" : "End Of Day/Close Store\n(To Be Implemented)", "event" : "CS"},
  {"id" : 2, "name" : "Logout\n(To Be Implemented)", "event" : "LO"},
];

List<Map<dynamic, dynamic>> menuItemLeftNested = [
  {"id" : 0, "name" : "POS Menu", "event" : "POS_MENU"},
  {"id" : 1, "name" : "End Of Day/Close Store", "event" : "CS"},
  {"id" : 2, "name" : "Logout", "event" : "LO"},
];


List<Map<dynamic, dynamic>> clientOption = [
  {"id" : 0, "name" : "Total/Finalize", "event" : OPTION_TOTAL},
  {"id" : 1, "name" : "Payment","event" : OPTION_PAYMENT},
  {"id" : 4, "name" : "Void", "event" : OPTION_VOID},
  {"id" : 5, "name" : "Refund", "event" : OPTION_REFUND},
  {"id" : 6, "name" : "Discount", "event" : OPTION_DISCOUNT},
  {"id" : 7, "name" : "Item", "event" : OPTION_ITEM},
  {"id" : 8, "name" : "Lookup", "event" : OPTION_LOOKUP},
];


List<Map<dynamic, dynamic>> clientOptionTop = [
  {"id" : 0, "name" : "Setup", "event" : OPTION_SETUP},
  {"id" : 1, "name" : "Advance", "event" : OPTION_ADVANCE},
  {"id" : 2, "name" : "Return", "event" : OPTION_RETURN },
  {"id" : 3, "name" : "Keyboard", "event" : "KEY_BOARD" },
];


List<Map<dynamic, dynamic>> departCateOptionList = [
  {"id" : 0, "name" : "Department", "event" : "DEPARTMENT"},
  {"id" : 1, "name" : "Category", "event" : "CATEGORY"},
  {"id" : 2, "name" : "Sub Category", "event" : "SUB_CATEGORY"},
];

List<Map<dynamic, dynamic>> sectionOptionList = [
  {"id" : 0, "name" : "section", "event" : "SECTION"},
];

List<Map<dynamic, dynamic>> discountTaxOptionList = [
  {"id" : 0, "name" : "Discount", "event" : "DISCOUNT"},
  {"id" : 1, "name" : "Tax", "event" : "TAX"},
];

List<Map<dynamic, dynamic>> vendorOptionList = [
  {"id" : 0, "name" : "vendor", "event" : "VENDOR"},
];


List<Map<dynamic, dynamic>> employeeOptionList = [
  {"id" : 0, "name" : "Employee Setting", "event" : "EMPLOYEE"},
];