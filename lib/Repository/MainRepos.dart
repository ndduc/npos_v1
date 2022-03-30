// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/AddResponseModel.dart';
import 'package:npos/Model/ApiModel/ItemCodePaginationModel.dart';
import 'package:npos/Model/ApiModel/UpcPaginationModel.dart';
import 'package:npos/Model/ApiModel/UserPaginationModel.dart';
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/DiscountModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/SectionModel.dart';
import 'package:npos/Model/TaxModel.dart';
import 'package:npos/Model/UpcModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Model/VendorModel.dart';
import 'package:npos/Service/Http/CategoryService.dart';
import 'package:npos/Service/Http/DepartmentService.dart';
import 'package:npos/Service/Http/DiscountService.dart';
import 'package:npos/Service/Http/ItemCodeService.dart';
import 'package:npos/Service/Http/ProductService.dart';
import 'package:npos/Service/Http/SectionService.dart';
import 'package:npos/Service/Http/TaxService.dart';
import 'package:npos/Service/Http/UpcService.dart';
import 'package:npos/Service/Http/UserService.dart' ;
import 'package:npos/Service/Http/LocationService.dart' ;
import 'package:npos/Service/Http/VendorService.dart';

class MainRepository{

  //region ITEM CODE
  Future<ItemCodeModel> GetByItemCode(String userId, String locId, String productId, String itemCode) {
    return ItemCodeService().GetByItemCode(userId, locId, productId, itemCode);
  }

  Future<ItemCodePaginationModel> GetItemCodePaginate(String userId, String locId, String productId, String limit, String offset, String order) {
    return ItemCodeService().GetItemCodePaginate( userId,  locId,  productId, limit, offset, order);
  }

  Future<bool> VerifyItemCode(String userId, String locId, String productId, String ItemCode){
    return ItemCodeService().VerifyItemCode( userId,  locId,  productId,  ItemCode);
  }

  Future<bool> AddItemCode(String userId, String locId, String productId, String ItemCode){
    return ItemCodeService().AddItemCode( userId,  locId,  productId,  ItemCode);
  }

  Future<bool> RemoveItemCode(String userId, String locId, String productId, String ItemCode){
    return ItemCodeService().RemoveItemCode( userId,  locId,  productId,  ItemCode);
  }
  //endregion

  //region UPC
  Future<UpcModel> GetByUpc(String userId, String locId, String productId, String itemCode) {
    return UpcService().GetByUpc(userId, locId, productId, itemCode);
  }

  Future<UpcPaginationModel> GetUpcPaginate(String userId, String locId, String productId, String limit, String offset, String order) {
    return UpcService().GetUpcPaginate( userId,  locId,  productId, limit, offset, order);
  }

  Future<bool> VerifyUpc(String userId, String locId, String productId, String ItemCode){
    return UpcService().VerifyUpc( userId,  locId,  productId,  ItemCode);
  }

  Future<bool> AddUpc(String userId, String locId, String productId, String ItemCode){
    return UpcService().AddUpc( userId,  locId,  productId,  ItemCode);
  }

  Future<bool> RemoveUpc(String userId, String locId, String productId, String ItemCode){
    return UpcService().RemoveUpc( userId,  locId,  productId,  ItemCode);
  }
  //endregion

  //region USER
  Future<UserModel> AuthorizingUser(String name, String password) {
    return UserService().AuthorizingUser(name, password);
  }

  Future<UserPaginationModel> GetUserPagination(String userId, String locationId, Map<String, dynamic> optionalParameter) {
    return UserService().GetUserPagination(userId, locationId, optionalParameter);
  }
  //endregion

  //region LOCATION
  Future<List<LocationModel>> GetLocationByUser(String uid) {
    return LocationService().GetLocationByUser(uid);
  }
  //endregion

  //region PRODUCT
  Future<ProductModel> GetProductByParamMap(String userId, String locId, Map<String, dynamic> param) {
    return ProductService().GetProductByMap(userId, locId, param);
  }

  Future<int> GetProductPaginateCount(String userId, String locId, Map<String, dynamic> optionalParameter) {
    return ProductService().GetProductPaginateCount(userId, locId, optionalParameter);
  }

  Future<List<ProductModel>>GetProductPaginateByIndex(String userId, String locId, Map<String, dynamic> optionalParameter) {
    print(optionalParameter);
    return ProductService().GetProductPaginateByIndex(userId, locId, optionalParameter);
  }

  Future<AddResponseModel> AddProduct(ProductModel productModel, String locationId) {
    return ProductService().AddProduct(productModel, locationId);
  }

  Future<AddResponseModel> UpdateProduct(ProductModel productModel, String locationId) {
    return ProductService().UpdateProduct(productModel, locationId);
  }
  //endregion

  //region DEPARTMENT
  Future<List<DepartmentModel>>GetDepartments(String userId, String locId) {
    return DepartmentService().GetDepartments(userId, locId);
  }

  Future<int> GetDepartmentPaginateCount(String userId, String locId, String searchType) {
    return DepartmentService().GetDepartmentPaginateCount(userId, locId, searchType);
  }

  Future<List<DepartmentModel>>GetDepartmentPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) {
    return DepartmentService().GetDepartmentPaginateByIndex(userId, locId, searchType, startIdx, endIdx);
  }

  Future<DepartmentModel> GetDepartmentById (String userId, String locId, String departmentId) {
    return DepartmentService().GetDepartmentById(userId, locId, departmentId);
  }

  Future<List<DepartmentModel>>GetDepartmentByDescription(String userId, String locId, String description) {
    return DepartmentService().GetDepartmentByDescription(userId, locId, description);
  }

  Future<bool>AddDepartment(String userId, String locId, Map<String, String> param){
    return DepartmentService().AddDepartment(userId, locId, param);
  }

  Future<bool>UpdateDepartment(String userId, String locId, Map<String, String> param){
    return DepartmentService().UpdateDepartment(userId, locId, param);
  }
  //endregion

  //region CATEGORY
  Future<List<CategoryModel>>GetCategory(String userId, String locId) {
    return CategoryService().GetCategory(userId, locId);
  }

  Future<int> GetCategoryPaginateCount(String userId, String locId, String searchType) {
    return CategoryService().GetCategoryPaginateCount(userId, locId, searchType);
  }

  Future<List<CategoryModel>>GetCategoryPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) {
    return CategoryService().GetCategoryPaginateByIndex(userId, locId, searchType, startIdx, endIdx);
  }

  Future<CategoryModel> GetCategoryById (String userId, String locId, String categoryId) {
    return CategoryService().GetCategoryById(userId, locId, categoryId);
  }

  Future<List<CategoryModel>>GetCategoryByDescription(String userId, String locId, String description) {
    return CategoryService().GetCategoryByDescription(userId, locId, description);
  }

  Future<bool>AddCategory(String userId, String locId, Map<String, String> param){
    return CategoryService().AddCategory(userId, locId, param);
  }

  Future<bool>UpdateCategory(String userId, String locId, Map<String, String> param){
    return CategoryService().UpdateCategory(userId, locId, param);
  }
  //endregion

  //region VENDOR
  Future<List<VendorModel>>GetVendors(String userId, String locId) {
    return VendorService().GetVendor(userId, locId);
  }

  Future<int> GetVendorPaginateCount(String userId, String locId, String searchType) {
    return VendorService().GetVendorPaginateCount(userId, locId, searchType);
  }

  Future<List<VendorModel>>GetVendorPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) {
    return VendorService().GetVendorPaginateByIndex(userId, locId, searchType, startIdx, endIdx);
  }

  Future<VendorModel> GetVendorById (String userId, String locId, String vendorId) {
    return VendorService().GetVendorById(userId, locId, vendorId);
  }

  Future<List<VendorModel>>GetVendorByDescription(String userId, String locId, String description) {
    return VendorService().GetVendorByDescription(userId, locId, description);
  }

  Future<bool>AddVendor(String userId, String locId, Map<String, String> param){
    return VendorService().AddVendor(userId, locId, param);
  }

  Future<bool>UpdateVendor(String userId, String locId, Map<String, String> param){
    return VendorService().UpdateVendor(userId, locId, param);
  }
  //endregion

  //region SECTION
  Future<List<SectionModel>>GetSections(String userId, String locId) {
    return SectionService().GetSection(userId, locId);
  }

  Future<int> GetSectionPaginateCount(String userId, String locId, String searchType) {
    return SectionService().GetSectionPaginateCount(userId, locId, searchType);
  }

  Future<List<SectionModel>>GetSectionPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) {
    return SectionService().GetSectionPaginateByIndex(userId, locId, searchType, startIdx, endIdx);
  }

  Future<SectionModel> GetSectionById (String userId, String locId, String sectionId) {
    return SectionService().GetSectionById(userId, locId, sectionId);
  }

  Future<List<SectionModel>>GetSectionByDescription(String userId, String locId, String description) {
    return SectionService().GetSectionByDescription(userId, locId, description);
  }

  Future<bool>AddSection(String userId, String locId, Map<String, String> param){
    return SectionService().AddSection(userId, locId, param);
  }

  Future<bool>UpdateSection(String userId, String locId, Map<String, String> param){
    return SectionService().UpdateSection(userId, locId, param);
  }
  //endregion

  //region DISCOUNT
  Future<List<DiscountModel>>GetDiscounts(String userId, String locId) {
    return DiscountService().GetDiscount(userId, locId);
  }

  Future<int> GetDiscountPaginateCount(String userId, String locId, String searchType) {
    return DiscountService().GetDiscountPaginateCount(userId, locId, searchType);
  }

  Future<List<DiscountModel>>GetDiscountPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) {
    return DiscountService().GetDiscountPaginateByIndex(userId, locId, searchType, startIdx, endIdx);
  }

  Future<DiscountModel> GetDiscountById (String userId, String locId, String discountId) {
    return DiscountService().GetDiscountById(userId, locId, discountId);
  }

  Future<List<DiscountModel>>GetDiscountByDescription(String userId, String locId, String description) {
    return DiscountService().GetDiscountByDescription(userId, locId, description);
  }

  Future<bool>AddDiscount(String userId, String locId, Map<String, String> param){
    return DiscountService().AddDiscount(userId, locId, param);
  }

  Future<bool>UpdateDiscount(String userId, String locId, Map<String, String> param){
    return DiscountService().UpdateDiscount(userId, locId, param);
  }
  //endregion

  //region TAX
  Future<List<TaxModel>>GetTax(String userId, String locId) {
    return TaxService().GetTax(userId, locId);
  }

  Future<int> GetTaxPaginateCount(String userId, String locId, String searchType) {
    return TaxService().GetTaxPaginateCount(userId, locId, searchType);
  }

  Future<List<TaxModel>>GetTaxPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) {
    return TaxService().GetTaxPaginateByIndex(userId, locId, searchType, startIdx, endIdx);
  }

  Future<TaxModel> GetTaxById (String userId, String locId, String taxId) {
    return TaxService().GetTaxById(userId, locId, taxId);
  }

  Future<List<TaxModel>>GetTaxByDescription(String userId, String locId, String description) {
    return TaxService().GetTaxByDescription(userId, locId, description);
  }

  Future<bool>AddTax(String userId, String locId, Map<String, String> param){
    return TaxService().AddTax(userId, locId, param);
  }

  Future<bool>UpdateTax(String userId, String locId, Map<String, String> param){
    return TaxService().UpdateTax(userId, locId, param);
  }
  //endregion
}