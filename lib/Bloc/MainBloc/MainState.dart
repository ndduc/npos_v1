// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/DiscountModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/SectionModel.dart';
import 'package:npos/Model/TaxModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Model/VendorModel.dart';

abstract class MainState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// Must have on every screen
//region GENERIC STATE
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
//endregion

/// Use this when loading layout state -- LAYOUT indicate nested screen within the parent screen
//region 2nd GENERIC STATE
class Generic2ndInitialState extends MainState{ }
class Generic2ndLoadingState extends MainState{ }
class Generic2ndLoadedState extends MainState{
  dynamic genericData;
  Generic2ndLoadedState.GenericData({this.genericData});
}
class Generic2ndErrorState extends MainState{
  final error;
  Generic2ndErrorState({this.error});
}
//endregion

//region GENERIC
/// Description: Loaded Value On Dropdown -- this look like it loadding DEFAULT value
class DropDownLoadedState extends MainState {
  int dropDownValue;
  String dropDownType;
  DropDownLoadedState({required this.dropDownValue, required this.dropDownType});
}

/// Description: Switching between multiple different layout on the same screen
class SwitchScreenLoadedState extends MainState {
  String toWhere;
  UserModel userModel;
  SwitchScreenLoadedState({required this.toWhere, required this.userModel});
}

/// Description: Indicate event when user toggle on and off the ADD and UPDATE button
class AddItemModeLoaded extends MainState {
  bool? isAdded;
  AddItemModeLoaded({required this.isAdded});
}

/// Description: Response to the Add and Update Department request
class AddUpdateDepartmentLoaded extends MainState {
  bool? isSuccess;
  AddUpdateDepartmentLoaded({required this.isSuccess});
}
//endregion

//region AUTHORIZE
class StateLoadedOnAuthorizingUser extends MainState {
  UserModel? userModel;
  StateLoadedOnAuthorizingUser({this.userModel});
}

class CheckAuthorizeStateLoading extends MainState {}

class CheckAuthorizeStateLoaded extends MainState {
  UserModel? userModel;
  CheckAuthorizeStateLoaded({required this.userModel});
}
//endregion

//region NAVIGATION
class GenericNavigateStateLoaded extends MainState {
  UserModel? userModel;
  GenericNavigateStateLoaded({required  this.userModel});
}
//endregion

//region PRODUCT
class ProductLoadingState extends MainState {}

class ProductLoadedState extends MainState{
  ProductModel? productModel;
  ProductLoadedState({required this.productModel});
}

class ProductPaginateLoadingState extends MainState {}

class ProductPaginateCountLoadedState extends MainState{
  int? count;
  ProductPaginateCountLoadedState({required this.count});
}

class ProductPaginateLoadedState extends MainState{
  List<ProductModel>? listProductModel;
  ProductPaginateLoadedState({required this.listProductModel});
}
//endregion

//region DEPARTMENT
class DepartmentPaginateLoadingState extends MainState {}

class DepartmentLoadingState extends MainState {}

class DepartmentPaginateCountLoadedState extends MainState{
  int? count;
  DepartmentPaginateCountLoadedState({required this.count});
}

class DepartmentPaginateLoadedState extends MainState{
  List<DepartmentModel>? listDepartmentModel;
  DepartmentPaginateLoadedState({required this.listDepartmentModel});
}

class DepartmentByDescriptionLoadedState extends MainState{
  List<DepartmentModel>? listDepartmentModel;
  DepartmentByDescriptionLoadedState({required this.listDepartmentModel});
}

class DepartmentLoadedState extends MainState{
  DepartmentModel? departmentModel;
  DepartmentLoadedState({required this.departmentModel});
}
//endregion

//region CATEGORY
class CategoryPaginateLoadingState extends MainState {}

class CategoryLoadingState extends MainState {}

class CategoryPaginateCountLoadedState extends MainState{
  int? count;
  CategoryPaginateCountLoadedState({required this.count});
}

class CategoryPaginateLoadedState extends MainState{
  List<CategoryModel>? listCategoryModel;
  CategoryPaginateLoadedState({required this.listCategoryModel});
}

class CategoryByDescriptionLoadedState extends MainState{
  List<CategoryModel>? listCategoryModel;
  CategoryByDescriptionLoadedState({required this.listCategoryModel});
}

class CategoryLoadedState extends MainState{
  CategoryModel? categoryModel;
  CategoryLoadedState({required this.categoryModel});
}
//endregion

//region VENDOR
class VendorPaginateLoadingState extends MainState {}

class VendorLoadingState extends MainState {}

class VendorPaginateCountLoadedState extends MainState{
  int? count;
  VendorPaginateCountLoadedState({required this.count});
}

class VendorPaginateLoadedState extends MainState{
  List<VendorModel>? listVendorModel;
  VendorPaginateLoadedState({required this.listVendorModel});
}

class VendorByDescriptionLoadedState extends MainState{
  List<VendorModel>? listVendorModel;
  VendorByDescriptionLoadedState({required this.listVendorModel});
}

class VendorLoadedState extends MainState{
  VendorModel? vendorModel;
  VendorLoadedState({required this.vendorModel});
}
//endregion

//region SECTION
class SectionPaginateLoadingState extends MainState {}

class SectionLoadingState extends MainState {}

class SectionPaginateCountLoadedState extends MainState{
  int? count;
  SectionPaginateCountLoadedState({required this.count});
}

class SectionPaginateLoadedState extends MainState{
  List<SectionModel>? listSectionModel;
  SectionPaginateLoadedState({required this.listSectionModel});
}

class SectionByDescriptionLoadedState extends MainState{
  List<SectionModel>? listSectionModel;
  SectionByDescriptionLoadedState({required this.listSectionModel});
}

class SectionLoadedState extends MainState{
  SectionModel? sectionModel;
  SectionLoadedState({required this.sectionModel});
}
//endregion

//region DISCOUNT
class DiscountPaginateLoadingState extends MainState {}

class DiscountLoadingState extends MainState {}

class DiscountPaginateCountLoadedState extends MainState{
  int? count;
  DiscountPaginateCountLoadedState({required this.count});
}

class DiscountPaginateLoadedState extends MainState{
  List<DiscountModel>? listDiscountModel;
  DiscountPaginateLoadedState({required this.listDiscountModel});
}

class DiscountByDescriptionLoadedState extends MainState{
  List<DiscountModel>? listDiscountModel;
  DiscountByDescriptionLoadedState({required this.listDiscountModel});
}

class DiscountLoadedState extends MainState{
  DiscountModel? discountModel;
  DiscountLoadedState({required this.discountModel});
}
//endregion

//region TAX
class TaxPaginateLoadingState extends MainState {}

class TaxLoadingState extends MainState {}

class TaxPaginateCountLoadedState extends MainState{
  int? count;
  TaxPaginateCountLoadedState({required this.count});
}

class TaxPaginateLoadedState extends MainState{
  List<TaxModel>? listTaxModel;
  TaxPaginateLoadedState({required this.listTaxModel});
}

class TaxByDescriptionLoadedState extends MainState{
  List<TaxModel>? listTaxModel;
  TaxByDescriptionLoadedState({required this.listTaxModel});
}

class TaxLoadedState extends MainState{
  TaxModel? taxModel;
  TaxLoadedState({required this.taxModel});
}
//endregion

