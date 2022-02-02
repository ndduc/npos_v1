// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';

enum MainEvent{
  fetchAlbums,

  //region USER REQUEST
  Event_VerifyUser,
  Check_Authorization,
  //endregion

  //region LOCATION REQUEST
  Event_GetLocationByUser,
  //endregion

  //region PRODUCT REQUEST
  Event_GetProductByParamMap,
  Event_GetProductPaginateCount,
  Event_GetProductPaginate,
  Event_GetAllDependency,
  Event_AddProduct,
  Event_UpdateProduct,
  //endregion

  //region DEPARTMENT REQUEST
  Event_GetDepartments,
  Event_GetDepartmentPaginateCount,
  Event_GetDepartmentPaginate,
  Event_GetDepartmentById,
  Event_GetDepartmentByDescription,
  Event_AddDepartment,
  Event_UpdateDepartment,
  //endregion

  //region CATEGORY REQUEST
  Event_GetCategory,
  Event_GetCategoryPaginateCount,
  Event_GetCategoryPaginate,
  Event_GetCategoryById,
  Event_GetCategoryByDescription,
  Event_AddCategory,
  Event_UpdateCategory,
  //endregion

  //region VENDOR REQUEST
  Event_GetVendors,
  Event_GetVendorPaginateCount,
  Event_GetVendorPaginate,
  Event_GetVendorById,
  Event_GetVendorByDescription,
  Event_AddVendor,
  Event_UpdateVendor,
  //endregion

  //region SECTION REQUEST
  Event_GetSections,
  Event_GetSectionPaginateCount,
  Event_GetSectionPaginate,
  Event_GetSectionById,
  Event_GetSectionByDescription,
  Event_AddSection,
  Event_UpdateSection,
  //endregion

  //region DISCOUNT REQUEST
  Event_GetDiscounts,
  Event_GetDiscountPaginateCount,
  Event_GetDiscountPaginate,
  Event_GetDiscountById,
  Event_GetDiscountByDescription,
  Event_AddDiscount,
  Event_UpdateDiscount,
  //endregion

  //region TAX REQUEST
  Event_GetTax,
  Event_GetTaxPaginateCount,
  Event_GetTaxPaginate,
  Event_GetTaxById,
  Event_GetTaxByDescription,
  Event_AddTax,
  Event_UpdateTax,
  //endregion

  //region SNACK BAR
  Show_SnackBar,
  //endregion

  //region LOCAL EVENT
  Local_Event_Set_DefaultLocation,
  Local_Event_DropDown_SearchBy,
  Local_Event_Product_Mode,
  Local_Event_Switch_Screen,
  Local_Event_NewItem_Mode,     //use to toggle on and off the add button
  //endregion

  //region NAVIGATION
  Nav_Dialog_ItemCode_Add,
  Nav_Dialog_ItemCode_Update,
  Nav_Dialog_Upc,
  Nav_Dialog_Product_Add,
  Nav_Dialog_Product_Add_Yes,
  Nav_Dialog_Product_Add_No,
  Nav_Dialog_Product_Update,
  Nav_Dialog_Product_Update_Yes,
  Nav_Dialog_Product_Update_No,
  Nav_Dialog_Product_Add_Response,
  Nav_Dialog_Product_Update_Response,
  Nav_MainMenu, //Screen After Login
  Nav_Man_Product,
  Nav_Man_Dept,
  Nav_Man_Sec,
  Nav_Man_Disc,
  Nav_Man_Ven,
  Nav_Report_Inv,
  Nav_Report_Detail,
  Nav_Report_Daily,
  Nav_Report_Analysis,
  Nav_Man_Royal,
  Nav_Man_Point,
  Nav_Customer_Notification,
  Nav_Man_Social,
  Nav_ManEmp,
  Nav_Setup,
  Nav_POS_Client,
  Nav_Logout,
  Nav_EOD
  //endregion
}

class MainParam {
  String? userUid;
  String? userName;
  String? password;
  String? locationId;
  MainEvent? eventStatus;
  BuildContext? context;
  dynamic snackBarContent;
  UserModel? userData;
  ProductModel? productData;
  int? index;
  Map<String, dynamic>? productParameter;
  Map<String, dynamic>? departmentParameter;
  Map<String, dynamic>? categoryParameter;
  Map<String, dynamic>? vendorParameter;
  Map<String, dynamic>? sectionParameter;
  Map<String, dynamic>? discountParameter;
  Map<String, dynamic>? taxParameter;
  Map<String, String>? optionalParameter;
  String? dropDownType;
  dynamic dropDownValue;
  String? toWhere;
  bool? isAdded;

  /// DIALOG
  MainParam.NavDialog({this.userData, this.productData, this.eventStatus, this.context, this.optionalParameter});

  /// PRODUCT
  MainParam.GetProductByParam({this.eventStatus, this.productParameter, this.userData});
  MainParam.AddProduct({required this.eventStatus, required this.productData, required this.locationId});
  MainParam.UpdateProduct({required this.eventStatus, required this.productData, required this.locationId});

  /// DEPARTMENT
  MainParam.GetDepartmentByParam({this.eventStatus, this.departmentParameter, this.userData});
  MainParam.AddUpdateDepartment({this.eventStatus, this.userData, this.departmentParameter});

  /// CATEGORY
  MainParam.GetCategoryByParam({this.eventStatus, this.categoryParameter, this.userData});
  MainParam.AddUpdateCategory({this.eventStatus, this.userData, this.categoryParameter});

  /// VENDOR
  MainParam.GetVendorByParam({this.eventStatus, this.vendorParameter, this.userData});
  MainParam.AddUpdateVendor({this.eventStatus, this.userData, this.vendorParameter});

  /// SECTION
  MainParam.GetSectionByParam({this.eventStatus, this.sectionParameter, this.userData});
  MainParam.AddUpdateSection({this.eventStatus, this.userData, this.sectionParameter});

  /// DISCOUNT
  MainParam.GetDiscountByParam({this.eventStatus, this.discountParameter, this.userData});
  MainParam.AddUpdateDiscount({this.eventStatus, this.userData, this.discountParameter});

  /// TAX
  MainParam.GetTaxByParam({this.eventStatus, this.taxParameter, this.userData});
  MainParam.AddUpdateTax({this.eventStatus, this.userData, this.taxParameter});

  /// AUTHORIZATION
  MainParam.GetAuthorization({this.eventStatus, this.userData});
  MainParam.SetDefaultLocation({this.eventStatus, this.userData, this.index});
  MainParam.VerifyUser({this.userName, this.password, this.eventStatus});
  MainParam.GetLocationByUser({this.userUid, this.eventStatus});

  MainParam.showSnackBar({this.context, this.snackBarContent, this.eventStatus});
  MainParam.GenericNavigator({this.context, this.eventStatus, this.userData});

  // Can be use on event of dropdown which take Map<int, string> as argument
  // Can also use for state management where Map<int, string> is being used. EX, Product Mode
  MainParam.DropDown({this.eventStatus, this.dropDownType, this.dropDownValue});

  MainParam.SwitchScreen({this.eventStatus, this.toWhere, this.userData});

  MainParam.AddItemMode({this.eventStatus, this.isAdded});


}