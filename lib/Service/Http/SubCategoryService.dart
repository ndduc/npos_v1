// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:npos/Constant/API/MapValues.dart';
import 'package:npos/Constant/API/NumberValues.dart';
import 'package:npos/Constant/API/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/SubCategoryModel.dart';

abstract class Service{
  Future<List<SubCategoryModel>> GetSubCategory(String userId, String locId);  // Just a simple get all
  Future<SubCategoryModel> GetSubCategoryById(String userId, String locId, String subCategoryId);
  Future<int>GetSubCategoryPaginateCount(String userId, String locId, String searchType);
  Future<List<SubCategoryModel>>GetSubCategoryPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx);
  Future<List<SubCategoryModel>>GetSubCategoryByDescription(String userId, String locId, String description);
  Future<bool>AddSubCategory(String userId, String locId, Map<String, String> param);
  Future<bool>UpdateSubCategory(String userId, String locId, Map<String, String> param);
  Future <List<SubCategoryModel>> GetSubCategoryByCategoryId(String userId, String locId, String categoryId);
}
class SubCategoryService extends Service{
  @override
  Future<List<SubCategoryModel>>GetSubCategory(String userId, String locId) async {
    List<SubCategoryModel> listModel = [];
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY_GET);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        List<dynamic> lstRes = json[BODY];
        for(int i = 0; i < lstRes.length; i++) {
          SubCategoryModel _model =  SubCategoryModel.mapLowerCase(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> GetSubCategoryPaginateCount(String userId, String locId, String searchType) async {
    Map<String, String> param = {
      "searchType" : searchType
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY_GET_COUNT);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        int response = jsonDecode(json[BODY]);
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<SubCategoryModel>>GetSubCategoryPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) async {
    List<SubCategoryModel> listModel = [];
    Map<String, String> param = {
      "searchType": searchType,
      "startIdx" : startIdx.toString(),
      "endIdx" : endIdx.toString()
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY_GET_PAGINATE);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        List<dynamic> lstRes = jsonDecode(json[BODY]);
        for(int i = 0; i < lstRes.length; i++) {
          SubCategoryModel _model =  SubCategoryModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future <SubCategoryModel> GetSubCategoryById(String userId, String locId, String subCategoryId) async {
    SubCategoryModel model;
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY + subCategoryId);
      var res = await http.get(
          url,
          headers: HEADER
      );
      ConsolePrint("RES", res.body);
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        Map<String, dynamic> mapRes = jsonDecode(json[BODY]);
        model = SubCategoryModel.map(mapRes);
        return model;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future <List<SubCategoryModel>> GetSubCategoryByCategoryId(String userId, String locId, String categoryId) async {
    List<SubCategoryModel> listModel = [];
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + categoryId + SUBCATEGORY);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        List<dynamic> lstRes = jsonDecode(json[BODY]);
        for(int i = 0; i < lstRes.length; i++) {
          SubCategoryModel _model =  SubCategoryModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<SubCategoryModel>>GetSubCategoryByDescription(String userId, String locId, String description) async {
    List<SubCategoryModel> listModel = [];
    Map<String, String> param = {
      "description": description,
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY_GET_BY_SUBCATEGORY);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        List<dynamic> lstRes = jsonDecode(json[BODY]);
        for(int i = 0; i < lstRes.length; i++) {
          SubCategoryModel _model =  SubCategoryModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }



  @override
  Future<bool>AddSubCategory(String userId, String locId, Map<String, String> param) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY_ADD);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      ConsolePrint("RES", res.body);
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        String response = json[BODY];
        if (response == OK) {
          return true;
        } else {
          return false;
        }
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool>UpdateSubCategory(String userId, String locId, Map<String, String> param) async {
    ConsolePrint("PARAM", param);
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SUBCATEGORY_UPDATE);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      ConsolePrint("RES", res.body);
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        String response = json[BODY];
        if (response == OK) {
          return true;
        } else {
          return false;
        }
      }
    } catch(e) {
      throw Exception(e);
    }
  }


}