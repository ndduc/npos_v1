// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:npos/Model/UserModel.dart';

enum MainEvent{
  fetchAlbums,
  Event_VerifyUser,
  Event_GetLocationByUser,
  Event_GetProductByParamMap,
  Show_SnackBar,
  Check_Authorization,
  Local_Event_Set_DefaultLocation,
  Local_Event_DropDown_SearchBy,
  Local_Event_Product_Mode,
  Local_Event_Switch_Screen,
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
}

class MainParam {
  String? userUid;
  String? userName;
  String? password;
  MainEvent? eventStatus;
  BuildContext? context;
  dynamic snackBarContent;
  UserModel? userData;
  int? index;
  Map<String, String>? productParameter;

  String? dropDownType;
  int? dropDownValue;

  String? toWhere;

  MainParam.GetProductByParam({this.eventStatus, this.productParameter, this.userData});
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
}