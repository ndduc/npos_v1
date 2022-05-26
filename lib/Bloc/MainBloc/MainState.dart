// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:npos/Model/AddResponseModel.dart';
import 'package:npos/Model/ApiModel/ItemCodePaginationModel.dart';
import 'package:npos/Model/ApiModel/UpcPaginationModel.dart';
import 'package:npos/Model/ApiModel/UserPaginationModel.dart';
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/DiscountModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:npos/Model/POSClientModel/ProductOrderModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/SectionModel.dart';
import 'package:npos/Model/TaxModel.dart';
import 'package:npos/Model/UpcModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Model/UserRelationModel.dart';
import 'package:npos/Model/VendorModel.dart';

import '../../Constant/Enum/CheckoutEnum.dart';

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
  Generic2ndLoadedState({this.genericData});
}
class Generic2ndErrorState extends MainState{
  final error;
  Generic2ndErrorState({this.error});
}
//endregion

//region GENERIC
/// Description: Loaded Value On Dropdown -- this look like it loadding DEFAULT value

class DropDownInitState extends MainState {}
class DropDownLoadingState extends MainState {}
class DropDownLoadedState extends MainState {
  dynamic dropDownValue;
  late String dropDownType;
  DropDownLoadedState({required this.dropDownValue, required this.dropDownType});
}
class DropDownErrorState extends MainState {
  final error;
  DropDownErrorState({this.error});
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

//region ITEM CODE
class ItemCodeGetInitState extends MainState{}
class ItemCodeGetLoadingState extends MainState{}
class ItemCodeGetLoadedState extends MainState{
  ItemCodePaginationModel response;
  String? selectedItemCode = "";
  ItemCodeGetLoadedState({required this.response, this.selectedItemCode});
}

class ItemCodeTableClickInitState extends MainState {}
class ItemCodeTableClickLoadingState extends MainState {}
class ItemCodeTableClickLoadedState extends MainState {
  ItemCodeModel response;
  ItemCodeTableClickLoadedState({required this.response});
}

class NewItemCodeClickInitState extends MainState {}
class NewItemCodeClickLoadingState extends MainState {}
class NewItemCodeClickLoadedState extends MainState {
  Map<String, dynamic> response;
  NewItemCodeClickLoadedState({required this.response});
}

class ItemCodeVerifyInitState extends MainState {}
class ItemCodeVerifyLoadingState extends MainState {}
class ItemCodeVerifyLoadedState extends MainState {
  bool response;
  ItemCodeVerifyLoadedState({required this.response});
}

class ItemCodeAddInitState extends MainState {}
class ItemCodeAddLoadingState extends MainState {}
class ItemCodeAddLoadedState extends MainState {
  bool response;
  ItemCodeAddLoadedState({required this.response});
}

class ItemCodeDeleteInitState extends MainState {}
class ItemCodeDeleteLoadingState extends MainState {}
class ItemCodeDeleteLoadedState extends MainState {
  bool response;
  ItemCodeDeleteLoadedState({required this.response});
}

class ItemCodeErrorState extends MainState{
  final error;
  ItemCodeErrorState({this.error});
}
//endregion

//region UPC
class UpcGetInitState extends MainState{}
class UpcGetLoadingState extends MainState{}
class UpcGetLoadedState extends MainState{
  UpcPaginationModel response;
  String? selectedUpc = "";
  UpcGetLoadedState({required this.response, this.selectedUpc});
}

class UpcTableClickInitState extends MainState {}
class UpcTableClickLoadingState extends MainState {}
class UpcTableClickLoadedState extends MainState {
  UpcModel response;
  UpcTableClickLoadedState({required this.response});
}

class NewUpcClickInitState extends MainState {}
class NewUpcClickLoadingState extends MainState {}
class NewUpcClickLoadedState extends MainState {
  Map<String, dynamic> response;
  NewUpcClickLoadedState({required this.response});
}

class UpcVerifyLoadingState extends MainState {}
class UpcVerifyInitState extends MainState {}
class UpcVerifyLoadedState extends MainState {
  bool response;
  UpcVerifyLoadedState({required this.response});
}

class UpcAddInitState extends MainState {}
class UpcAddLoadingState extends MainState {}
class UpcAddLoadedState extends MainState {
  bool response;
  UpcAddLoadedState({required this.response});
}

class UpcDeleteInitState extends MainState {}
class UpcDeleteLoadingState extends MainState {}
class UpcDeleteLoadedState extends MainState {
  bool response;
  UpcDeleteLoadedState({required this.response});
}

class UpcErrorState extends MainState{
  final error;
  UpcErrorState({this.error});
}
//endregion

//region USER
class UserPaginationInitState extends MainState {}
class UserPaginationLoadingState extends MainState {}
class UserPaginationLoadedState extends MainState {
  UserPaginationModel? response;
  UserPaginationLoadedState({required this.response});
}
class UserPaginationLoadedErrorState extends MainState{
  final error;
  UserPaginationLoadedErrorState({this.error});
}

class UserByIdInitState extends MainState {}
class UserByIdLoadingState extends MainState {}
class UserByIdLoadedState extends MainState {
  UserRelationModel? response;
  UserByIdLoadedState({required this.response});
}
class UserByIdLoadedErrorState extends MainState{
  final error;
  UserByIdLoadedErrorState({this.error});
}

//endregion USER

//region PRODUCT
class ProductLoadInitState extends MainState {}
class ProductLoadingState extends MainState {}

class ProductLoadedState extends MainState{
  ProductModel? productModel;
  ProductLoadedState({required this.productModel});
}

class ProductLoadErrorState extends MainState {
  final error;
  ProductLoadErrorState({this.error});
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

class ProductAddUpdateInitState extends MainState{}
class ProductAddUpdateLoadingState extends MainState{}
class ProductAddUpdateLoadedState extends MainState{
  AddResponseModel responseModel;
  ProductAddUpdateLoadedState({required this.responseModel});
}
class ProductAddUpdateErrorState extends MainState{
  final error;
  ProductAddUpdateErrorState({this.error});
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

/// Description: Response to the Add and Update Department request
class AddUpdateDepartmentLoaded extends MainState {
  bool? isSuccess;
  AddUpdateDepartmentLoaded({required this.isSuccess});
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

class CategoryDependencyInitState extends MainState{ }
class CategoryDependencyLoadingState extends MainState{ }
class CategoryDependencyLoadedState extends MainState{
  dynamic genericData;
  CategoryDependencyLoadedState.GenericData({this.genericData});
  CategoryDependencyLoadedState({this.genericData});
}
class CategoryDependencyErrorState extends MainState{
  final error;
  CategoryDependencyErrorState({this.error});
}

/// Description: Response to the Add and Update Department request
class AddUpdateCategoryLoaded extends MainState {
  bool? isSuccess;
  AddUpdateCategoryLoaded({required this.isSuccess});
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

class AddUpdateVendorLoaded extends MainState {
  bool? isSuccess;
  AddUpdateVendorLoaded({required this.isSuccess});
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

class AddUpdateSectionLoaded extends MainState {
  bool? isSuccess;
  AddUpdateSectionLoaded({required this.isSuccess});
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

class AddUpdateDiscountLoaded extends MainState {
  bool? isSuccess;
  AddUpdateDiscountLoaded({required this.isSuccess});
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

class AddUpdateTaxLoaded extends MainState {
  bool? isSuccess;
  AddUpdateTaxLoaded({required this.isSuccess});
}
//endregion

//region DIALOG PRODUCT
class DialogProductAddUpdateInitState extends MainState{}
class DialogProductAddUpdateLoadingState extends MainState{}
class DialogProductAddUpdateLoadedState extends MainState{
  dynamic response;
  bool sucess;
  DialogProductAddUpdateLoadedState({required this.sucess});
}
class DialogProductAddUpdateErrorState extends MainState{
  final error;
  DialogProductAddUpdateErrorState({this.error});
}
//endregion

//region CHECKOUT CLIENT

/// CHECKOUT
class CheckoutItemInit extends MainState {}
class CheckoutItemLoading extends MainState {}
class CheckoutItemLoaded extends MainState {
  ProductOrderModel? productOrderModel;
  CheckoutItemLoaded({required this.productOrderModel});
}
class CheckoutItemError extends MainState {
  final error;
  CheckoutItemError({this.error});
}

/// PAYMENT
class CheckoutPaymentsInit extends MainState {}
class CheckoutPaymentsLoading extends MainState {}
class CheckoutPaymentsLoaded extends MainState {}
class CheckoutPaymentsError extends MainState {
  final error;
  CheckoutPaymentsError({this.error});
}

/// ITEM
/// CHECKOUT DEPARTMENT -> CATEGORY -> SUB CATEGORY -> ITEM
class CheckoutItemsInit extends MainState {}
class CheckoutItemsLoading extends MainState {}
class CheckoutItemsLoaded extends MainState {
  /// holding category associates with selected department
  List<Map<dynamic, dynamic>> categoryAssociationModel = [];
  List<CategoryModel> categories = [];
  /// holding sub category associates with selected department
  List<Map<dynamic, dynamic>> subCategoryAssociationModel = [];
  /// holding item associates with selected dept, cat, sub cat
  List<Map<dynamic, dynamic>> productAssociationModel = [];

  /// selected option
  Enum option = CheckoutEnum.NONE;
  CheckoutItemsLoaded.Department();
  CheckoutItemsLoaded.Category({required this.categoryAssociationModel, required this.subCategoryAssociationModel, required this.option});
  CheckoutItemsLoaded.CategoryAsync({required this.categoryAssociationModel, required this.categories ,required this.subCategoryAssociationModel, required this.option});

  CheckoutItemsLoaded.SubCategory({required this.subCategoryAssociationModel, required this.option});
  CheckoutItemsLoaded.Product({required this.productAssociationModel, required this.option});
}
class CheckoutItemsError extends MainState {
  final error;
  CheckoutItemsError({this.error});
}

/// LOOKUP
class CheckoutLookupInit extends MainState {}
class CheckoutLookupLoading extends MainState {}
class CheckoutLookupLoaded extends MainState {}
class CheckoutLookupError extends MainState {
  final error;
  CheckoutLookupError({this.error});
}

/// KEYBOARD
class CheckoutKeyboardInit extends MainState {}
class CheckoutKeyboardLoading extends MainState {}
class CheckoutKeyboardLoaded extends MainState {
  bool isKeyboard;
  CheckoutKeyboardLoaded({required this.isKeyboard});
}
class CheckoutKeyboardError extends MainState {
  final error;
  CheckoutKeyboardError({this.error});
}

//endregion