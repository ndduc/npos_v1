// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Constant/API/MapValues.dart';
import 'package:npos/Constant/API/StringValues.dart';
import 'package:npos/Constant/Dummy/DummyValues.dart';
import 'package:npos/Constant/Enum/CheckoutEnum.dart';
import 'package:npos/Constant/UIEvent/addProductEvent.dart';
import 'package:npos/Constant/Values/StringValues.dart' as Value;
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
import 'package:npos/Model/POSClientModel/ProductCheckOutModel.dart';
import 'package:npos/Model/POSClientModel/ProductOrderModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/SectionModel.dart';
import 'package:npos/Model/SubCategoryModel.dart';
import 'package:npos/Model/TaxModel.dart';
import 'package:npos/Model/UpcModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Model/UserRelationModel.dart';
import 'package:npos/Model/VendorModel.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/Dialogs/CheckoutOverrideDiscountDialog.dart';
import 'package:npos/View/Component/Stateful/Dialogs/CheckoutRefundDialog.dart';
import 'package:npos/View/Component/Stateful/Dialogs/CheckoutVoidDialog.dart';
import 'package:npos/View/Component/Stateful/Dialogs/ProductDialogBlocAddUpdate.dart';
import 'package:npos/View/Component/Stateful/Dialogs/ProductDialogBlocItemCode.dart';
import 'package:npos/View/Component/Stateful/Dialogs/ProductDialogBlocUpc.dart';
import 'package:npos/View/DeptCategory/deptCategoryManagement.dart';
import 'package:npos/View/DiscTaxManagement/disTaxManagement.dart';
import 'package:npos/View/EmployeeManagement/employeeManagement.dart';
import 'package:npos/View/Home/homeMenu.dart';
import 'package:npos/View/LocationManagement/locationManagement.dart';
import 'package:npos/View/ProductManagement/productManagement.dart';
import 'package:npos/View/SectionManagement/sectionManagement.dart';
import 'package:npos/View/VenSupManagement/venSupManagement.dart';
import 'MainEvent.dart';
import 'package:npos/Repository/MainRepos.dart';
import 'dart:async';
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

    /// Navigate Switch
    navigateHelper(event);

    switch(event.eventStatus)
    {
      /// USER HTTP EVENT
      //region USER HTTP EVENT
      case MainEvent.Event_GetItemCodePagination:
        yield ItemCodeGetInitState();
        try {
          yield ItemCodeGetLoadingState();
          Map<String, String> param = event.optionalParameter as Map<String, String>;
          ProductModel productModel = event.productData as ProductModel;
          UserModel userModel = event.userData as UserModel;
          LocationModel? locationModel = userModel.defaultLocation;
          ItemCodePaginationModel response = await mainRepo.GetItemCodePaginate(userModel.uid.toString(),locationModel!.uid.toString(), productModel.uid.toString(),
              param["limit"].toString(), param["offset"].toString(), param["order"].toString());
          response.print();
          if (param["selectedItemCode"].toString() != "-1") {
            yield ItemCodeGetLoadedState(response: response, selectedItemCode: param["selectedItemCode"].toString());
          } else {
            yield ItemCodeGetLoadedState(response: response);
          }
        } catch (e) {
          yield ItemCodeErrorState(error: e);
        }
        break;
      //endregion USER HTTP EVENT
      /// ITEM CODE HTTP EVENT
      //region ITEM CODE HTTP EVENT
      case MainEvent.Event_GetUserPagination:
        yield UserPaginationInitState();
        try {
          yield UserPaginationLoadingState();
          Map<String, dynamic> param = event.userParameter as Map<String, dynamic>;
          ConsolePrint("Param",param);
          UserModel userModel = event.userData as UserModel;
          LocationModel? locationModel = userModel.defaultLocation;
          UserPaginationModel response = await mainRepo.GetUserPagination(userModel.uid.toString(),locationModel!.uid.toString(), param);
          yield UserPaginationLoadedState(response: response);

        } catch (e) {
          yield UserPaginationLoadedErrorState(error: e);
        }
      break;
      case MainEvent.Event_GetUserById_Local:
        yield UserByIdInitState();
        try {
          yield UserByIdLoadingState();
          UserRelationModel? locationModel = event.userRelationModel as UserRelationModel;
          yield UserByIdLoadedState(response: locationModel);

        } catch (e) {
          yield UserByIdLoadedErrorState(error: e);
        }
        break;
      case MainEvent.Event_ItemCodeVerify:
        yield ItemCodeVerifyInitState();
        try {
          yield ItemCodeVerifyLoadingState();
          Map<String, dynamic> param = event.itemCodeParameter as Map<String, dynamic>;

          bool response = await mainRepo.VerifyItemCode(param[USER_ID], param[LOCATION_ID], param[PRODUCT_ID], param[ITEM_CODE]);
          
          
          yield ItemCodeVerifyLoadedState(response: response);
        } catch (e) {
          yield ItemCodeErrorState(error: e);
        }
        break;
      case MainEvent.Event_ItemCodeAdd:
        yield ItemCodeAddInitState();
        try {
          yield ItemCodeAddLoadingState();
          Map<String, dynamic> param = event.itemCodeParameter as Map<String, dynamic>;
          bool response = await mainRepo.AddItemCode(param[USER_ID], param[LOCATION_ID], param[PRODUCT_ID], param[ITEM_CODE]);
          yield ItemCodeAddLoadedState(response: response);
        } catch (e) {
          yield ItemCodeErrorState(error: e);
        }
        break;

      case MainEvent.Event_ItemCodeDelete:
        yield ItemCodeDeleteInitState();
        try {
          yield ItemCodeDeleteLoadingState();
          Map<String, dynamic> param = event.itemCodeParameter as Map<String, dynamic>;
          bool response = await mainRepo.RemoveItemCode(param[USER_ID], param[LOCATION_ID], param[PRODUCT_ID], param[ITEM_CODE]);
          yield ItemCodeDeleteLoadedState(response: response);
        } catch (e) {
          yield ItemCodeErrorState(error: e);
        }
        break;
      //endregion

      /// UPC HTTP EVENT
      //region UPC HTTP EVENT
        case MainEvent.Event_GetUpcPagination:
          print('MainEvent.Event_GetUpcPagination');
          yield UpcGetInitState();
          try {
            yield UpcGetLoadingState();
            Map<String, String> param = event.optionalParameter as Map<String, String>;
            ProductModel productModel = event.productData as ProductModel;
            UserModel userModel = event.userData as UserModel;
            LocationModel? locationModel = userModel.defaultLocation;
            UpcPaginationModel response = await mainRepo.GetUpcPaginate(userModel.uid.toString(),locationModel!.uid.toString(), productModel.uid.toString(),
                param["limit"].toString(), param["offset"].toString(), param["order"].toString());

            if (param["selectedUpc"].toString() != "-1") {
              yield UpcGetLoadedState(response: response, selectedUpc: param["selectedUpc"].toString());
            } else {
              yield UpcGetLoadedState(response: response);
            }
          } catch (e) {
            yield UpcErrorState(error: e);
          }
          break;
        case MainEvent.Event_UpcVerify:

          yield UpcVerifyInitState();
          try {
            yield UpcVerifyLoadingState();
            Map<String, dynamic> param = event.upcParameter as Map<String, dynamic>;
            bool response = await mainRepo.VerifyUpc(param[USER_ID], param[LOCATION_ID], param[PRODUCT_ID], param[UPC_STR]);
            yield UpcVerifyLoadedState(response: response);
          } catch (e) {
            yield UpcErrorState(error: e);
          }
          break;
        case MainEvent.Event_UpcAdd:
          yield UpcAddInitState();
          try {
            yield UpcAddLoadingState();
            Map<String, dynamic> param = event.upcParameter as Map<String, dynamic>;
            bool response = await mainRepo.AddUpc(param[USER_ID], param[LOCATION_ID], param[PRODUCT_ID], param[UPC_STR]);
            yield UpcAddLoadedState(response: response);
          } catch (e) {
            yield UpcErrorState(error: e);
          }
          break;

        case MainEvent.Event_UpcDelete:
          yield UpcDeleteInitState();
          try {
            yield UpcDeleteLoadingState();
            Map<String, dynamic> param = event.upcParameter as Map<String, dynamic>;
            bool response = await mainRepo.RemoveUpc(param[USER_ID], param[LOCATION_ID], param[PRODUCT_ID], param[UPC_STR]);
            yield UpcDeleteLoadedState(response: response);
          } catch (e) {
            yield UpcErrorState(error: e);
          }
          break;
      //endregion

      /// PRODUCT HTTP EVENT
      //region PRODUCT HTTP EVENT
      case MainEvent.Event_GetProductByParamMap:
       yield GenericInitialState();
        try {
          yield ProductLoadingState();
          Map<String, dynamic> param = event.productParameter as Map<String, dynamic>;
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          ProductModel model = await mainRepo.GetProductByParamMap(userId, locId!, param);
          yield ProductLoadedState(productModel: model);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetProductByParamMapAdv:
        yield ProductLoadInitState();
        try {
          yield ProductLoadingState();
          Map<String, dynamic> param = event.productParameter as Map<String, dynamic>;
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          ProductModel model = await mainRepo.GetProductByParamMap(userId, locId!, param);
          yield ProductLoadedState(productModel: model);
        } catch (e) {
          yield ProductLoadErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetProductPaginateCount:
        yield GenericInitialState();
        try {
          yield ProductPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          int count = await mainRepo.GetProductPaginateCount(userId, locId!, event.productParameter!);
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
          List<ProductModel> listModel = await mainRepo.GetProductPaginateByIndex(userId, locId!,event.productParameter!);
          yield ProductPaginateLoadedState(listProductModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetAllDependency:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<DepartmentModel> dept = await mainRepo.GetDepartments(userId, locId.toString());
          List<SectionModel> sec = await mainRepo.GetSections(userId, locId.toString());
          List<CategoryModel> cate = await mainRepo.GetCategory(userId, locId.toString());
          List<VendorModel> ven = await mainRepo.GetVendors(userId, locId.toString());
          List<DiscountModel> disc = await mainRepo.GetDiscounts(userId, locId.toString());
          List<TaxModel> tax = await mainRepo.GetTax(userId, locId.toString());

          Map<String, dynamic> res = {
            "department" : dept.isNotEmpty ? dept : null,
            "section" : sec.isNotEmpty ? sec : null,
            "category" : cate.isNotEmpty ? cate : null,
            "vendor": ven.isNotEmpty ? ven : null,
            "discount" : disc.isNotEmpty ? disc : null,
            "tax": tax.isNotEmpty ? tax : null
          };
          yield Generic2ndLoadedState(genericData: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddProduct:
        yield ProductAddUpdateInitState();
        try {
          yield ProductAddUpdateLoadingState();
          ProductModel productModel = event.productData!;
          String locationId = event.locationId!;
          AddResponseModel addEventResponse = await mainRepo.AddProduct(productModel, locationId);
          addEventResponse.print();
          yield ProductAddUpdateLoadedState(responseModel: addEventResponse);
        } catch (e) {
          yield ProductAddUpdateErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateProduct:
        yield ProductAddUpdateInitState();
        try {
          yield ProductAddUpdateLoadingState();
          ProductModel productModel = event.productData!;
          String locationId = event.locationId!;
          AddResponseModel addEventResponse = await mainRepo.UpdateProduct(productModel, locationId);
          yield ProductAddUpdateLoadedState(responseModel: addEventResponse);
        } catch (e) {
          yield ProductAddUpdateErrorState(error: e);
        }
        break;
      //endregion

      /// DEPARTMENT HTTP EVENT
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

      /// SUB CATEGORY HTTP EVENT
      //region CATEGORY HTTP EVENT
      case MainEvent.Event_GetSubCategoryPaginateCount:
        yield SubCategoryPaginateCountInitState();
        try {
          yield SubCategoryPaginateCountLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetSubCategoryPaginateCount(userId, locId!, searchType);
          yield SubCategoryPaginateCountLoadedState(count: count);
        } catch (e) {
          yield SubCategoryPaginateCountErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSubCategoryPaginate:
        yield SubCategoryPaginateInitState();
        try {
          yield SubCategoryPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          List<SubCategoryModel> listModel = await mainRepo.GetSubCategoryPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield SubCategoryPaginateLoadedState(listSubCategoryModel: listModel);
        } catch (e) {
          yield SubCategoryPaginateErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSubCategoryByDescription:
        yield SubCategoryByDescriptionInitState();
        try {
          yield SubCategoryByDescriptionLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.categoryParameter!["description"];
          List<SubCategoryModel> listModel = await mainRepo.GetSubCategoryByDescription(userId, locId!, description);
          yield SubCategoryByDescriptionLoadedState(listSubCategoryModel: listModel);
        } catch (e) {
          yield SubCategoryByDescriptionErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSubCategoryById:
        yield SubCategoryInitState();
        try {
          yield SubCategoryLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String subCategoryId = event.subCategoryParameter!["subCategoryId"];
          SubCategoryModel res = await mainRepo.GetSubCategoryById(userId, locId!, subCategoryId);
          yield SubCategoryLoadedState(subCategoryModel: res);
        } catch (e) {
          yield SubCategoryErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSubCategory:
      // This will be replaced with paginate endpoint - not valid at the moment
        yield SubCategoryPaginateInitState();
        try {
          yield SubCategoryPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<SubCategoryModel> res = await mainRepo.GetSubCategory(userId, locId!);
          yield SubCategoryPaginateLoadedState(listSubCategoryModel: res);
        } catch (e) {
          yield SubCategoryPaginateErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddSubCategory:
        yield AddUpdateSubCategoryInitState();
        try {
          yield AddUpdateSubCategoryLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.subCategoryParameter!["desc"],
            "note":event.subCategoryParameter!["note"],
            "cat_uid":event.subCategoryParameter!["cat_uid"]
          };
          bool res = await mainRepo.AddSubCategory(userId, locId!, param);
          yield AddUpdateSubCategoryLoaded(isSuccess: res);
        } catch (e) {
          yield AddUpdateSubCategoryErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateSubCategory:
        yield AddUpdateSubCategoryInitState();
        try {
          yield AddUpdateSubCategoryLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.subCategoryParameter!["desc"],
            "note":event.subCategoryParameter!["note"],
            "id":event.subCategoryParameter!["id"],
            "cat_uid":event.subCategoryParameter!["cat_uid"]
          };

          ConsolePrint("UPDATE", "SUB");
          bool res = await mainRepo.UpdateSubCategory(userId, locId!, param);
          yield AddUpdateSubCategoryLoaded(isSuccess: res);
        } catch (e) {
          yield AddUpdateSubCategoryErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSubCategoryDependency:
        yield SubCategoryDependencyInitState();
        try {
          yield SubCategoryDependencyLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<CategoryModel> cat = await mainRepo.GetCategory(userId, locId.toString());

          /// Dependency could be more than 1 object thus we use map as a container
          yield SubCategoryDependencyLoadedState(catList: cat);
        } catch (e) {
          yield SubCategoryDependencyErrorState(error: e);
        }
        break;
    //endregion

      /// CATEGORY HTTP EVENT
      //region CATEGORY HTTP EVENT
      case MainEvent.Event_GetCategoryPaginateCount:
        yield GenericInitialState();
        try {
          yield CategoryPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetCategoryPaginateCount(userId, locId!, searchType);
          yield CategoryPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetCategoryPaginate:
        yield GenericInitialState();
        try {
          yield CategoryPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          List<CategoryModel> listModel = await mainRepo.GetCategoryPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield CategoryPaginateLoadedState(listCategoryModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetCategoryByDescription:
        yield GenericInitialState();
        try {
          yield CategoryPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.categoryParameter!["description"];
          List<CategoryModel> listModel = await mainRepo.GetCategoryByDescription(userId, locId!, description);
          yield CategoryByDescriptionLoadedState(listCategoryModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetCategoryById:
        yield GenericInitialState();
        try {
          yield CategoryLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String categoryId = event.categoryParameter!["categoryId"];
          CategoryModel res = await mainRepo.GetCategoryById(userId, locId!, categoryId);
          yield CategoryLoadedState(categoryModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetCategory:
      // This will be replaced with paginate endpoint - not valid at the moment
        yield GenericInitialState();
        try {
          yield CategoryPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<CategoryModel> res = await mainRepo.GetCategory(userId, locId!);
          yield CategoryPaginateLoadedState(listCategoryModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddCategory:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.categoryParameter!["desc"],
            "note":event.categoryParameter!["note"],
            "dept_uid":event.categoryParameter!["dept_uid"]
          };
          bool res = await mainRepo.AddCategory(userId, locId!, param);
          yield AddUpdateCategoryLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateCategory:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.categoryParameter!["desc"],
            "note":event.categoryParameter!["note"],
            "id":event.categoryParameter!["id"],
            "dept_uid":event.categoryParameter!["dept_uid"]
          };
          bool res = await mainRepo.UpdateCategory(userId, locId!, param);
          yield AddUpdateCategoryLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetCategoryDependency:
        yield CategoryDependencyInitState();
        try {
          yield CategoryDependencyLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<DepartmentModel> dept = await mainRepo.GetDepartments(userId, locId.toString());

          /// Dependency could be more than 1 object thus we use map as a container
          Map<String, dynamic> res = {
            "department" : dept.isNotEmpty ? dept : null,
          };
          yield CategoryDependencyLoadedState(genericData: res);
        } catch (e) {
          yield CategoryDependencyErrorState(error: e);
        }
        break;
      //endregion

      /// VENDOR HTTP EVENT
      //region VENDOR HTTP EVENT
      case MainEvent.Event_GetVendorPaginateCount:
        yield GenericInitialState();
        try {
          yield VendorPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetVendorPaginateCount(userId, locId!, searchType);
          yield VendorPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetVendorPaginate:
        yield GenericInitialState();
        try {
          yield VendorPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          List<VendorModel> listModel = await mainRepo.GetVendorPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield VendorPaginateLoadedState(listVendorModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetVendorByDescription:
        yield GenericInitialState();
        try {
          yield VendorPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.vendorParameter!["description"];
          List<VendorModel> listModel = await mainRepo.GetVendorByDescription(userId, locId!, description);
          yield VendorByDescriptionLoadedState(listVendorModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetVendorById:
        yield GenericInitialState();
        try {
          yield VendorLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String vendorId = event.vendorParameter!["vendorId"];
          VendorModel res = await mainRepo.GetVendorById(userId, locId!, vendorId);
          yield VendorLoadedState(vendorModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetVendors:
      // This will be replaced with paginate endpoint - not valid at the moment
        yield GenericInitialState();
        try {
          yield VendorPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<VendorModel> res = await mainRepo.GetVendors(userId, locId!);
          yield VendorPaginateLoadedState(listVendorModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddVendor:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.vendorParameter!["desc"],
            "note":event.vendorParameter!["note"]
          };
          bool res = await mainRepo.AddVendor(userId, locId!, param);
          yield AddUpdateVendorLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateVendor:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.vendorParameter!["desc"],
            "note":event.vendorParameter!["note"],
            "id":event.vendorParameter!["id"]
          };
          bool res = await mainRepo.UpdateVendor(userId, locId!, param);
          yield AddUpdateVendorLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      //endregion

      /// SECTION HTTP EVENT
      //region SECTION HTTP EVENT
      case MainEvent.Event_GetSectionPaginateCount:
        yield GenericInitialState();
        try {
          yield SectionPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetSectionPaginateCount(userId, locId!, searchType);
          yield SectionPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSectionPaginate:
        yield GenericInitialState();
        try {
          yield SectionPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          List<SectionModel> listModel = await mainRepo.GetSectionPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield SectionPaginateLoadedState(listSectionModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSectionByDescription:
        yield GenericInitialState();
        try {
          yield SectionPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.sectionParameter!["description"];
          List<SectionModel> listModel = await mainRepo.GetSectionByDescription(userId, locId!, description);
          yield SectionByDescriptionLoadedState(listSectionModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSectionById:
        yield GenericInitialState();
        try {
          yield SectionLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String sectionId = event.sectionParameter!["sectionId"];
          SectionModel res = await mainRepo.GetSectionById(userId, locId!, sectionId);
          yield SectionLoadedState(sectionModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetSections:
      // This will be replaced with paginate endpoint - not valid at the moment
        yield GenericInitialState();
        try {
          yield SectionPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<SectionModel> res = await mainRepo.GetSections(userId, locId!);
          yield SectionPaginateLoadedState(listSectionModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddSection:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.sectionParameter!["desc"],
            "note":event.sectionParameter!["note"]
          };
          bool res = await mainRepo.AddSection(userId, locId!, param);
          yield AddUpdateSectionLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateSection:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.sectionParameter!["desc"],
            "note":event.sectionParameter!["note"],
            "id":event.sectionParameter!["id"]
          };
          bool res = await mainRepo.UpdateSection(userId, locId!, param);
          yield AddUpdateSectionLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      //endregion

      /// DISCOUNT HTTP EVENT
      //region DISCOUNT HTTP EVENT
      case MainEvent.Event_GetDiscountPaginateCount:
        yield GenericInitialState();
        try {
          yield DiscountPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetDiscountPaginateCount(userId, locId!, searchType);
          yield DiscountPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDiscountPaginate:
        yield GenericInitialState();
        try {
          yield DiscountPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          List<DiscountModel> listModel = await mainRepo.GetDiscountPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield DiscountPaginateLoadedState(listDiscountModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDiscountByDescription:
        yield GenericInitialState();
        try {
          yield DiscountPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.discountParameter!["description"];
          List<DiscountModel> listModel = await mainRepo.GetDiscountByDescription(userId, locId!, description);
          yield DiscountByDescriptionLoadedState(listDiscountModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDiscountById:
        yield GenericInitialState();
        try {
          yield DiscountLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String discountId = event.discountParameter!["discountId"];
          DiscountModel res = await mainRepo.GetDiscountById(userId, locId!, discountId);
          yield DiscountLoadedState(discountModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetDiscounts:
      // This will be replaced with paginate endpoint - not valid at the moment
        yield GenericInitialState();
        try {
          yield DiscountPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<DiscountModel> res = await mainRepo.GetDiscounts(userId, locId!);
          yield DiscountPaginateLoadedState(listDiscountModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddDiscount:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.discountParameter!["desc"],
            "note":event.discountParameter!["note"]
          };
          bool res = await mainRepo.AddDiscount(userId, locId!, param);
          yield AddUpdateDiscountLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateDiscount:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.discountParameter!["desc"],
            "note":event.discountParameter!["note"],
            "id":event.discountParameter!["id"]
          };
          bool res = await mainRepo.UpdateDiscount(userId, locId!, param);
          yield AddUpdateDiscountLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      //endregion

      /// TAX HTTP EVENT
      //region TAX HTTP EVENT
      case MainEvent.Event_GetTaxPaginateCount:
        yield GenericInitialState();
        try {
          yield TaxPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int count = await mainRepo.GetTaxPaginateCount(userId, locId!, searchType);
          yield TaxPaginateCountLoadedState(count: count);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetTaxPaginate:
        yield GenericInitialState();
        try {
          yield TaxPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String searchType = event.productParameter!["searchType"];
          int startIdx = event.productParameter!["startIdx"];
          int endIdx = event.productParameter!["endIdx"];
          List<TaxModel> listModel = await mainRepo.GetTaxPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
          yield TaxPaginateLoadedState(listTaxModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetTaxByDescription:
        yield GenericInitialState();
        try {
          yield TaxPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String description = event.taxParameter!["description"];
          List<TaxModel> listModel = await mainRepo.GetTaxByDescription(userId, locId!, description);
          yield TaxByDescriptionLoadedState(listTaxModel: listModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetTaxById:
        yield GenericInitialState();
        try {
          yield TaxLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          String taxId = event.taxParameter!["taxId"];
          TaxModel res = await mainRepo.GetTaxById(userId, locId!, taxId);
          yield TaxLoadedState(taxModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_GetTax:
      // This will be replaced with paginate endpoint - not valid at the moment
        yield GenericInitialState();
        try {
          yield TaxPaginateLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          List<TaxModel> res = await mainRepo.GetTax(userId, locId!);
          yield TaxPaginateLoadedState(listTaxModel: res);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      case MainEvent.Event_AddTax:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.taxParameter!["desc"],
            "note":event.taxParameter!["note"]
          };
          bool res = await mainRepo.AddTax(userId, locId!, param);
          yield AddUpdateTaxLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      case MainEvent.Event_UpdateTax:
        yield Generic2ndInitialState();
        try {
          yield Generic2ndLoadingState();
          String userId = event.userData!.uid;
          String? locId = event.userData!.defaultLocation!.uid;
          Map<String, String> param = {
            "desc": event.taxParameter!["desc"],
            "note":event.taxParameter!["note"],
            "id":event.taxParameter!["id"]
          };
          bool res = await mainRepo.UpdateTax(userId, locId!, param);
          yield AddUpdateTaxLoaded(isSuccess: res);
        } catch (e) {
          yield Generic2ndErrorState(error: e);
        }
        break;
      //endregion

      /// USER HTTP EVENT
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

      /// LOCAL EVENT
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
      /// ADV BLOCK --- Non adv will be replaced by ADV in the future, any future development will be using ADV
      //region ADV
      case MainEvent.Local_Event_DropDown_SearchBy:
        yield DropDownInitState();
        try {
          yield DropDownLoadingState();
          yield DropDownLoadedState(dropDownType: event.dropDownType as String, dropDownValue:  event.dropDownValue as dynamic);
        } catch (e) {
          yield DropDownErrorState(error: e);
        }
        break;
      case MainEvent.Local_Event_DropDown_SearchBy_Adv:
        yield GenericInitialState();
        try {
          yield GenericLoadingState();
          yield DropDownLoadedState(dropDownType: event.dropDownType as String, dropDownValue:  event.dropDownValue as dynamic);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
      //endregion
      case MainEvent.Local_Event_Set_DefaultLocation:
        yield GenericLoadingState();
        try {
          userModel = event.userData as UserModel;
          userModel!.defaultLocation = userModel!.locationList[event.index as int];
          yield GenericLoadedState.GenericData(genericData: userModel);
        } catch (e) {
          yield GenericErrorState(error: e);
        }
        break;
        //endregion

      //region LOCAL EVENT ITEM CODE
      case MainEvent.Event_ItemCodeTableClick:
        yield ItemCodeTableClickInitState();
        try {
          yield ItemCodeTableClickLoadingState();
          yield ItemCodeTableClickLoadedState(response: event.itemCodeData as ItemCodeModel);
        } catch (e) {
          yield ItemCodeErrorState(error: e);
        }
      break;
      case MainEvent.Event_NewItemCodeClick:
        yield NewItemCodeClickInitState();
        try {
          yield NewItemCodeClickLoadingState();
          yield NewItemCodeClickLoadedState(response: event.itemCodeParameter as Map<String, dynamic>);
        } catch (e) {
          yield ItemCodeErrorState(error: e);
        }
      break;
      //endregion

      //region LOCAL EVENT UPC
      case MainEvent.Event_UpcTableClick:
        yield UpcTableClickInitState();
        try {
          yield UpcTableClickLoadingState();
          yield UpcTableClickLoadedState(response: event.upcData as UpcModel);
        } catch (e) {
          yield UpcErrorState(error: e);
        }
        break;
      case MainEvent.Event_NewUpcClick:
        yield NewUpcClickInitState();
        try {
          yield NewUpcClickLoadingState();
          yield NewUpcClickLoadedState(response: event.upcParameter as Map<String, dynamic>);
        } catch (e) {
          yield UpcErrorState(error: e);
        }
        break;
    //endregion

      /// SNACK BAR
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

      /// DIALOG - PRODUCT
      /// Pop up once update or add product to confirm
      //region DIALOG PRODUCT
      case MainEvent.Nav_Dialog_Product_Add:
        dynamic val;
        yield DialogProductAddUpdateInitState();
        try {
          yield DialogProductAddUpdateLoadingState();
          await showGeneralDialog(
            barrierLabel: "Barrier",
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 500),
            context: event.context as BuildContext,
            pageBuilder: (_, __, ___) {
              return ProductDialogBlocAddUpdate(whoAmI: EVENT_PRODUCT_ADD, productModel: event.productData, userModel:  event.userData, optionalParam:  event.optionalParameter);
            },
            transitionBuilder: (_, anim, __, child) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:SlideTransition(
                    position:
                    Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                    child: child,
                  ));
            },
          ).then((value) => {
            val = value
          }).whenComplete(() {}
          );
          yield DialogProductAddUpdateLoadedState(sucess: val);
        } catch (e) {
          yield DialogProductAddUpdateErrorState(error:  e);
        }
        break;
      case MainEvent.Nav_Dialog_Product_Add_No:
        Navigator.pop(event.context as BuildContext, false);
        break;
      case MainEvent.Nav_Dialog_Product_Add_Yes:
        Navigator.pop(event.context as BuildContext, true);
        yield DialogProductAddUpdateLoadedState(sucess: true);
        break;
      case MainEvent.Nav_Dialog_Product_Update:
        dynamic val;
        yield DialogProductAddUpdateInitState();
        try {
          yield DialogProductAddUpdateLoadingState();
          await showGeneralDialog(
            barrierLabel: "Barrier",
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: Duration(milliseconds: 500),
            context: event.context as BuildContext,
            pageBuilder: (_, __, ___) {
              return ProductDialogBlocAddUpdate(whoAmI: EVENT_PRODUCT_UPDATE, productModel: event.productData, userModel:  event.userData, optionalParam:  event.optionalParameter);
            },
            transitionBuilder: (_, anim, __, child) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:SlideTransition(
                    position:
                    Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                    child: child,
                  ));
            },
          ).then((value) => {
            val = value
          }).whenComplete(() {}
          );
          yield DialogProductAddUpdateLoadedState(sucess: val);
        } catch (e) {
          yield DialogProductAddUpdateErrorState(error:  e);
        }
        break;
      case MainEvent.Nav_Dialog_Product_Update_No:
        Navigator.pop(event.context as BuildContext, false);
        break;
      //endregion

      /// CHECKOUT ITEM
      //region CHECKOUT ITEM
      case MainEvent.Event_Add_Item_Checkout:
        yield CheckoutItemInit();
        try {
          yield CheckoutItemLoading();
          ProductOrderModel newProductOrderModel = event.productOrder as ProductOrderModel ;
          newProductOrderModel.transaction[0].quantity = 2;
          newProductOrderModel.transaction[0].subTotal = 10;

          ProductCheckOutModel prod1 = ProductCheckOutModel();
          prod1.uid = "PRODUCT_123_2";
          prod1.description = "TEST PRODUCT 2";
          prod1.cost = 1.00;
          prod1.price = 5.00;
          prod1.subTotal = 5.00;
          prod1.quantity = 1;
          prod1.transactionType = Value.PURCHASE;
          prod1.productModelId = prod1.transactionType + "_" + prod1.uid!;


          newProductOrderModel.transaction.add(prod1);
          newProductOrderModel.orderSubTotal = newProductOrderModel.orderSubTotal + prod1.price.toDouble();
          newProductOrderModel.orderQuantity = newProductOrderModel.orderQuantity + prod1.quantity.toDouble();
          yield CheckoutItemLoaded(productOrderModel: newProductOrderModel);
        } catch (e) {
          yield CheckoutItemError(error:  e);
        }
        break;
      case MainEvent.Event_Payments:
        yield CheckoutPaymentsInit();
        try {
          yield CheckoutPaymentsLoading();
          yield CheckoutPaymentsLoaded();
        } catch (e) {
          yield CheckoutPaymentsError(error: e);
        }
        break;
      case MainEvent.Event_Items:
        yield CheckoutItemsInit();
        try {
          yield CheckoutItemsLoading();
          yield CheckoutItemsLoaded.Department();
        } catch (e) {
          yield CheckoutItemsError(error: e);
        }
        break;
      case MainEvent.Event_Department_POS:
        Map<String, String> dept = event.optionalParameter as Map<String, String>;
        yield CheckoutItemsInit();
        try {
          yield CheckoutItemsLoading();
          List<Map<dynamic, dynamic>> categoryAssociationModel = [];
          List<Map<dynamic, dynamic>> firstSubAssociationModel = [];
          Enum checkoutOption = CheckoutEnum.CATEGORY;
          for(int i = 0; i < dummyCategory.length; i++) {
            if (dummyCategory[i]["Department"] == int.parse(dept["id"].toString())) {
              categoryAssociationModel.add(dummyCategory[i]);
            }
          }

          if (categoryAssociationModel.isNotEmpty) {
            for(int i = 0; i < dummySubCategory.length; i++) {
              if (dummySubCategory[i]["Category"] == categoryAssociationModel[0]["id"]) {
                firstSubAssociationModel.add(dummySubCategory[i]);
              }
            }
          }

          /// Once fired, we will know the department's uid
          /// Use it to fire off get category by department's uid
          String departmentUid = dept["department_uid"].toString();
          String locationUid = dept["location_uid"].toString();
          String userUid = dept["user_uid"].toString();

          ConsolePrint("DEPT ID", departmentUid);
          List<CategoryModel> categories = await mainRepo.GetCategoryByDepartmentId(userUid, locationUid, departmentUid);

          for(int i = 0; i < categories.length; i++) {
            categories[i].print();
          }

          yield CheckoutItemsLoaded.Category(categoryAssociationModel: categoryAssociationModel, subCategoryAssociationModel: firstSubAssociationModel, option: checkoutOption);
        } catch (e) {
          yield CheckoutItemsError(error: e);
        }
        break;
      case MainEvent.Event_Category_POS:
        dynamic cat =  event.optionalParameter as Map<String, String>;
        yield CheckoutItemsInit();
        try {
          yield CheckoutItemsLoading();
          List<Map<dynamic, dynamic>> subCategoryAssociationModel = [];
          Enum checkoutOption = CheckoutEnum.SUBCATEGORY;
          for(int i = 0; i < dummySubCategory.length; i++) {
            if (dummySubCategory[i]["Category"] == int.parse(cat["id"])) {
              subCategoryAssociationModel.add(dummySubCategory[i]);
            }
          }
          yield CheckoutItemsLoaded.SubCategory(subCategoryAssociationModel: subCategoryAssociationModel, option: checkoutOption);
        } catch (e) {
          yield CheckoutItemsError(error: e);
        }
        break;
      case MainEvent.Event_SubCategory_POS:
        yield CheckoutItemsInit();
        try {
          yield CheckoutItemsLoading();
          List<Map<dynamic, dynamic>> productAssociationModel = dummyItem;
          Enum checkoutOption = CheckoutEnum.PRODUCT;
          yield CheckoutItemsLoaded.Product(productAssociationModel: productAssociationModel, option: checkoutOption);
        } catch (e) {
          yield CheckoutItemsError(error: e);
        }
        break;
      case MainEvent.Event_Lookup:
        yield CheckoutLookupInit();
        try {
          yield CheckoutLookupLoading();
          yield CheckoutLookupLoaded();
        } catch (e) {
          yield CheckoutLookupError(error: e);
        }
        break;
      case MainEvent.Event_Keyboard_OpenClose:
        ConsolePrint("BLOC", "VOID DIALOG");
        yield CheckoutKeyboardInit();
        try {
          yield CheckoutKeyboardLoading();
          bool isKeyboard = event.isKeyboard as bool;
          yield CheckoutKeyboardLoaded(isKeyboard: isKeyboard);
        } catch (e) {
          yield CheckoutKeyboardError(error: e);
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
      case MainEvent.Nav_POS_Client:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:ClientView(userData: event.userData));
            }));
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
      case MainEvent.Nav_ManEmp:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:EmployeeManagement(userData: event.userData));
            }));
        break;
      case MainEvent.Nav_ManLoc:
        Navigator.push(
            event.context as BuildContext,
            MaterialPageRoute(builder: (context) {
              return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                  child:LocationManagement(userData: event.userData));
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
      case MainEvent.Nav_Dialog_ItemCode_Update:
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return ProductDialogBlocItemCode(userModel: event.userData, whoAmI: EVENT_ITEMCODE_UPDATE, productMode: event.productData,);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
      case MainEvent.Nav_Dialog_ItemCode_Add:
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return ProductDialogBlocItemCode(userModel: event.userData, whoAmI: EVENT_ITEMCODE_ADD, productMode: event.productData,);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
      case MainEvent.Nav_Dialog_Upc_Update:
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return ProductDialogBlocUpc(userModel: event.userData, whoAmI: EVENT_UPC_UPDATE, productMode: event.productData,);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
      case MainEvent.Nav_Dialog_Upc_Add:
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return ProductDialogBlocUpc(userModel: event.userData, whoAmI: EVENT_UPC_ADD, productMode: event.productData,);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
      case MainEvent.Nav_Event_POS_VOID_Dialog:
        ConsolePrint("BLOC", "VOID DIALOG");
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return CheckoutVoidDialog(userModel: event.userData);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
      case MainEvent.Nav_Event_POS_OVERRIDE_Dialog:
        ConsolePrint("BLOC", "VOID DIALOG");
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return CheckoutOverrideDiscountDialog(userModel: event.userData);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
      case MainEvent.Nav_Event_POS_REFUND_Dialog:
        ConsolePrint("BLOC", "VOID DIALOG");
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: event.context as BuildContext,
          pageBuilder: (_, __, ___) {
            return CheckoutRefundDialog(userModel: event.userData);
          },
          transitionBuilder: (_, anim, __, child) {
            return  BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:SlideTransition(
                  position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                  child: child,
                ));
          },
        );
        break;
    }
  }
  //endregion
}