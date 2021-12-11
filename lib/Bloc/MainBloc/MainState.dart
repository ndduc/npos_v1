// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';

abstract class MainState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GenericInitialState extends MainState{ }
class GenericLoadingState extends MainState{ }
class GenericLoadedState extends MainState{
  dynamic genericData;
  GenericLoadedState.GenericData({this.genericData});
}
class GenericErrorState extends MainState{
  final error;
  GenericErrorState({this.error});
}


class StateLoadedOnAuthorizingUser extends MainState {
  UserModel? userModel;
  StateLoadedOnAuthorizingUser({this.userModel});
}

class CheckAuthorizeStateLoading extends MainState {}

class CheckAuthorizeStateLoaded extends MainState {
  UserModel? userModel;
  CheckAuthorizeStateLoaded({required this.userModel});
}

/*NAVIGATOR*/
class GenericNavigateStateLoaded extends MainState {
  UserModel? userModel;
  GenericNavigateStateLoaded({required  this.userModel});
}

class ProductLoadingState extends MainState {}
class ProductLoadedState extends MainState{
  ProductModel? productModel;
  ProductLoadedState({required this.productModel});
}

class DropDownLoadedState extends MainState {
  int dropDownValue;
  String dropDownType;

  DropDownLoadedState({required this.dropDownValue, required this.dropDownType});
}

