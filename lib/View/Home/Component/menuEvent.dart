// ignore_for_file: file_names
// ignore_for_file: library_prefixes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Constant/UiEvent/menuEvent.dart';
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
    switch(event){
      case MENU_MAN_PROD:
        print("PRODUCT EVENT CLICKED\t\t" + userData.firstName.toString());
        context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_Man_Product, context: context, userData: userData));
        break;
      case MENU_MAN_DEPTCATE:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DeptCateManagement()));
        break;
      case MENU_MAN_SEC:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SectionManagement()));
        break;
      case MENU_MAN_DISTAX:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DisTaxManagement()));
        break;
      case MENU_MAN_VEN:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => VendorManagement()));
        break;
      case MENU_REPORT_INV:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => InventoryReport()));
        break;
      case MENU_REPORT_DE:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DetailReport()));
        break;
      case MENU_REPORT_DAI:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DailyReport()));
        break;
      case MENU_REPORT_ANA:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PerformReport()));
        break;
      case MENU_MAN_CUS_ROYAL:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RoyalManagement()));
        break;
      case MENU_MAN_POINT:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PointManagement()));
        break;
      case MENU_MAN_CUS_NOTI:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NotifyManagement()));
        break;
      case MENU_MAN_SOC:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SocialManagement()));
        break;
      case MENU_MAN_EMP:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EmployeeManagement()));
        break;
      case MENU_MAN_LOC:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LocationManagement()));
        break;
      case MENU_SETUP:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SystemManagement()));
        break;
      default:
        break;
    }
  };
}