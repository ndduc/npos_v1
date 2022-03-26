// ignore_for_file: file_names
// ignore_for_file: library_prefixes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Constant/UIEvent/menuEvent.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/DailyReport/dailyReport.dart';
import 'package:npos/View/DeptCategory/deptCategoryManagement.dart';
import 'package:npos/View/DetailReport/detailReport.dart';
import 'package:npos/View/DiscTaxManagement/disTaxManagement.dart';
import 'package:npos/View/EmployeeManagement/employeeManagement.dart';
import 'package:npos/View/InventoryReport/inventoryReport.dart';
import 'package:npos/View/LocationManagement/locationManagement.dart';
import 'package:npos/View/NotifyManagement/notifyManagement.dart';
import 'package:npos/View/PerformReport/performReport.dart';
import 'package:npos/View/PointManagement/pointManagement.dart';
import 'package:npos/View/RoyalManagement/royalManagement.dart';
import 'package:npos/View/SectionManagement/sectionManagement.dart';
import 'package:npos/View/SocialManagement/socialManagement.dart';
import 'package:npos/View/SystemManagement/systemManagement.dart';
import 'package:npos/View/VenSupManagement/venSupManagement.dart';

GestureTapCallback menuClickEvent(int index, BuildContext context, UserModel userData) {
  return () {
    String event = UIItem.menuItem[index]["event"];
    ConsolePrint("EVENT", event);
    switch(event){
      case MENU_MAN_PROD:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Product, context: context, userData: userData));
        break;
      case MENU_MAN_DEPTCATE:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Dept, context: context, userData: userData));
        break;
      case MENU_MAN_SEC:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Sec, context: context, userData: userData));
        break;
      case MENU_MAN_DISTAX:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Disc, context: context, userData: userData));
        break;
      case MENU_MAN_VEN:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Ven, context: context, userData: userData));
        break;
      case MENU_REPORT_INV:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Report_Inv, context: context, userData: userData));
        break;
      case MENU_REPORT_DE:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Report_Detail, context: context, userData: userData));
        break;
      case MENU_REPORT_DAI:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Report_Daily, context: context, userData: userData));
        break;
      case MENU_REPORT_ANA:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Report_Analysis, context: context, userData: userData));
        break;
      case MENU_MAN_CUS_ROYAL:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Royal, context: context, userData: userData));
        break;
      case MENU_MAN_POINT:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Point, context: context, userData: userData));
        break;
      case MENU_MAN_CUS_NOTI:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Customer_Notification, context: context, userData: userData));
        break;
      case MENU_MAN_SOC:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Social, context: context, userData: userData));
        break;
      case MENU_MAN_EMP:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_ManEmp, context: context, userData: userData));
        break;
      case MENU_MAN_LOC:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_ManLoc, context: context, userData: userData));
        break;
      case MENU_SETUP:
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Setup, context: context, userData: userData));
        break;
      default:
        break;
    }
  };
}