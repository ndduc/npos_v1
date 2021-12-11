// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Home/homeMenu.dart';
import 'package:npos/View/ProductManagement/productManagement.dart';
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

    switch(event.eventStatus)
    {
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
      case MainEvent.Event_VerifyUser:
        yield GenericLoadingState();
        try {
          userModel = await mainRepo.AuthorizingUser(event.userName as String, event.password as String);
          yield StateLoadedOnAuthorizingUser(userModel: userModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
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
      default:
        break;
    }

  }

}