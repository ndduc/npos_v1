// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/DeptCategory/deptCategoryManagement.dart';
import 'package:npos/View/DiscTaxManagement/disTaxManagement.dart';
import 'package:npos/View/Home/homeMenu.dart';
import 'package:npos/View/ProductManagement/productManagement.dart';
import 'package:npos/View/SectionManagement/sectionManagement.dart';
import 'package:npos/View/VenSupManagement/venSupManagement.dart';
import 'MainEvent.dart';
import 'package:npos/Repository/MainRepos.dart';

import 'MainState.dart';


class MainBloc extends Bloc<MainParam,MainState>
{

  MainRepository mainRepo;
  MainBloc({required this.mainRepo}) : super(GenericInitialState());
  Map<String, dynamic>? dynamicMapResponse;
  bool isAuthorized = false;
  UserModel? userModel;

  @override
  Stream<MainState> mapEventToState(MainParam event) async* {

    // Navigate Switch
    navigateHelper(event);

    switch(event.eventStatus)
    {
      //region PRODUCT HTTP EVENT
      case MainEvent.Event_GetProductByParamMap:
       yield GenericInitialState();
        try {
          yield ProductLoadingState();
          Map<String, String> param = event.productParameter as Map<String, String>;
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          ProductModel model = await mainRepo.GetProductByParamMap(userId, locId!, param);
          yield ProductLoadedState(productModel: model);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetProductPaginateCount:
        yield GenericInitialState();
        try {
          yield ProductPaginateLoadingState();
          ConsolePrint("TEST", "TEST");
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetProductPaginateCount(userId, locId!, searchType);
          yield ProductPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetProductPaginate:
        yield GenericInitialState();
        try {
          yield ProductPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          ConsolePrint("Map Param", event.productParameter);
          List<ProductModel> listModel = await mainRepo.GetProductPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield ProductPaginateLoadedState(listProductModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
        //endregion
      //region DEPARTMENT HTTP EVENT
      case MainEvent.Event_GetDepartmentPaginateCount:
        yield GenericInitialState();
        try {
          yield DepartmentPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetDepartmentPaginateCount(userId, locId!, searchType);
          yield DepartmentPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDepartmentPaginate:
        yield GenericInitialState();
        try {
          yield DepartmentPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          ConsolePrint("Map Param", event.productParameter);
          List<DepartmentModel> listModel = await mainRepo.GetDepartmentPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield DepartmentPaginateLoadedState(listDepartmentModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDepartmentByDescription:
        yield GenericInitialState();
        try {
          yield DepartmentPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.departmentParameter!["description"];
          ConsolePrint("Map Param Event_GetDepartmentByDescription", event.departmentParameter);
          List<DepartmentModel> listModel = await mainRepo.GetDepartmentByDescription(userId, locId!, description);
          yield DepartmentByDescriptionLoadedState(listDepartmentModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDepartmentById:
        yield GenericInitialState();
        try {
          yield DepartmentLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String departmentId = event.departmentParameter!["departmentId"];
          DepartmentModel res = await mainRepo.GetDepartmentById(userId, locId!, departmentId);
          yield DepartmentLoadedState(departmentModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDepartments:
        // This will be replaced with paginate endpoint - not valid at the moment
        yield GenericInitialState();
        try {
          yield DepartmentPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<DepartmentModel> res = await mainRepo.GetDepartments(userId, locId!);
          yield DepartmentPaginateLoadedState(listDepartmentModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddDepartment:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.departmentParameter!["desc"],
            "note":event.departmentParameter!["note"]
          };
          bool res = await mainRepo.AddDepartment(userId, locId!, param);
          yield AddUpdateDepartmentLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateDepartment:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.departmentParameter!["desc"],
            "note":event.departmentParameter!["note"],
            "id":event.departmentParameter!["id"]
          };
          bool res = await mainRepo.UpdateDepartment(userId, locId!, param);
          yield AddUpdateDepartmentLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
        //endregion
      //region USER HTTP EVENT
      case MainEvent.Event_VerifyUser:
        yield GenericLoadingState();
        try {
          userModel = await mainRepo.AuthorizingUser(event.userName as String, event.password as String);
          yield StateLoadedOnAuthorizingUser(userModel: userModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Check_Authorization:
        try {
          yield GenericInitialState();
          bool _isAuthorized = event.userData!.isAuthorized;
          if(!_isAuthorized) {
            yield GenericErrorState(error: "UnAuthorized Access");
          } else {
            List<LocationModel> locationList = await mainRepo.GetLocationByUser(event.userData!.uid);
            event.userData!.locationList = locationList;
            yield CheckAuthorizeStateLoaded(userModel: event.userData as UserModel);
          }
        } catch (e) {
          yield GenericErrorState(error: "UnAuthorized Access With Exception\t\t" + e.toString());
        }
        break;
        //endregion
      //region LOCAL EVENT
      case MainEvent.Local_Event_NewItem_Mode:
        yield GenericInitialState();
        try {
          yield GenericLoadingState();
          yield AddItemModeLoaded(isAdded: event.isAdded);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Local_Event_Switch_Screen:
        yield GenericInitialState();
        try {
          yield GenericLoadingState();
          yield SwitchScreenLoadedState(toWhere: event.toWhere as String, userModel: event.userData as UserModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Local_Event_DropDown_SearchBy:
        yield GenericInitialState();
        try {
          yield GenericLoadingState();
          yield DropDownLoadedState(dropDownType: event.dropDownType as String, dropDownValue:  event.dropDownValue as int);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Local_Event_Set_DefaultLocation:
        yield GenericLoadingState();
        try {
          userModel = event.userData as UserModel;
          userModel!.defaultLocation = userModel!.locationList![event.index as int];
          yield GenericLoadedState.GenericData(genericData: userModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
        //endregion
      //region SNACK BAR
      case MainEvent.Show_SnackBar:
        yield GenericInitialState();
        try {
          final snackBar = SnackBar(
            content: Text(event.snackBarContent),
            backgroundColor: (Colors.red),
          );
          ScaffoldMessenger.of(event.context as BuildContext).showSnackBar(snackBar);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
        //endregion
      default:
        break;
    }
  }

  //region NAVIGATION
  void navigateHelper(MainParam event) {
    switch(event.eventStatus) {
      case MainEvent.Nav_Man_Product:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:ProductManagement(userData: event.userData));
            }));
        break;
      case MainEvent.Nav_MainMenu:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:HomeMenu(userData: event.userData));
            }));
        break;
      case MainEvent.Nav_Man_Disc:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:DisTaxManagement(userData: event.userData));
            }));
        break;
      case MainEvent.Nav_Man_Ven:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:VendorManagement(userData: event.userData));
            }));
        break;

      case MainEvent.Nav_Man_Dept:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:DeptCateManagement(userData: event.userData));
            }));
        break;
      case MainEvent.Nav_Man_Sec:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:SectionManagement(userData: event.userData));
            }));
        break;
    }
  }
  //endregion
}