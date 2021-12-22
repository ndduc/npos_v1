// ignore_for_file: file_names
// ignore_for_file: library_prefixes
List<Map<dynamic, dynamic>> menuItem = [
  {"id" : 0, "name" : "Product/Service Management", "event" : "MENU_PRODUCT_MAN"},
  {"id" : 1, "name" : "Department & Category", "event" : "MENU_DEPT/CATE_MAN"},
  {"id" : 2, "name" : "Section/Aisle", "event" : "MENU_SEC_MAN"},
  {"id" : 3, "name" : "Discount & Tax", "event" : "MENU_DIS/TAX_MAN"},
  {"id" : 4, "name" : "Vendor/Supplier", "event" : "MENU_VEN_MAN"},
  {"id" : 5, "name" : "Employee Management", "event" : "MENU_EMP_MAN"},
  {"id" : 6, "name" : "Store/Location Management", "event" : "MENU_LOC_MAN"},
  {"id" : 7, "name" : "System Setup", "event":"MENU_SETUP"},

  {"id" : 8, "name" : "Inventory Report", "event" : "MENU_INV_REPORT"},
  {"id" : 9, "name" : "Detail Report", "event" : "MENU_DE_REPORT"},
  {"id" : 10, "name" : "Daily Report", "event" : "MENU_DAI_REPORT"},
  {"id" : 11, "name" : "Analysis/Cashier Performance Report", "event" : "MENU_ANA_REPORT"},
  {"id" : 12, "name" : "Customer Royalty", "event" : "MENU_CUS_ROYAL"},
  {"id" : 13, "name" : "Point Management", "event" : "MENU_POINT_MAN"},
  {"id" : 14, "name" : "Customer Notification", "event" : "MENU_CUS_NOTI"},
  {"id" : 15, "name" : "Social Media Management", "event" : "MENU_SOC_MAN"},

];

List<Map<dynamic, dynamic>> menuItemLeft = [
  {"id" : 0, "name" : "POS Client", "event" : "PC"},
  {"id" : 1, "name" : "End Of Day/Close Store", "event" : "CS"},
  {"id" : 2, "name" : "Logout", "event" : "LO"},
];

List<Map<dynamic, dynamic>> menuItemLeftNested = [
  {"id" : 0, "name" : "POS Menu", "event" : "POS_MENU"},
  {"id" : 1, "name" : "End Of Day/Close Store", "event" : "CS"},
  {"id" : 2, "name" : "Logout", "event" : "LO"},
];


List<Map<dynamic, dynamic>> clientOption = [
  {"id" : 0, "name" : "Total/Finalize"},
  {"id" : 1, "name" : "Payment"},
  {"id" : 4, "name" : "Void"},
  {"id" : 5, "name" : "Refund"},
  {"id" : 6, "name" : "Discount"},
  {"id" : 7, "name" : "Item"},
  {"id" : 8, "name" : "Lookup"},
];


List<Map<dynamic, dynamic>> clientOptionTop = [
  {"id" : 0, "name" : "Return", "event" : "RT"},
  {"id" : 1, "name" : "Setup", "event" : "SET"},
  {"id" : 4, "name" : "Advance Option", "event" : "ADV_OPT"},
];


List<Map<dynamic, dynamic>> departCateOptionList = [
  {"id" : 0, "name" : "Department", "event" : "DEPARTMENT"},
  {"id" : 1, "name" : "Category", "event" : "CATEGORY"},
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
