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
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';

abstract class Service{
  Future<List<DepartmentModel>> GetDepartments(String userId, String locId);  // Just a simple get all
  Future<DepartmentModel> GetDepartmentById(String userId, String locId, String departmentId);
  Future<int>GetDepartmentPaginateCount(String userId, String locId, String searchType);
  Future<List<DepartmentModel>>GetDepartmentPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx);
  Future<List<DepartmentModel>>GetDepartmentByDescription(String userId, String locId, String description);
  Future<bool>AddDepartment(String userId, String locId, Map<String, String> param);
  Future<bool>UpdateDepartment(String userId, String locId, Map<String, String> param);
}
class DepartmentService extends Service{
  @override
  Future<List<DepartmentModel>>GetDepartments(String userId, String locId) async {
    List<DepartmentModel> listModel = [];
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT_GET);
      var res = await http.get(
          url,
          headers: HEADER,
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        List<dynamic> lstRes = json[BODY];
        for(int i = 0; i < lstRes.length; i++) {
          DepartmentModel _model =  DepartmentModel.mapLowerCase(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> GetDepartmentPaginateCount(String userId, String locId, String searchType) async {
    Map<String, String> param = {
      "searchType" : searchType
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT_GET_COUNT);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName(UTF_8),
          body: param
      );
      List<LocationModel> locationList = [];
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
  Future<List<DepartmentModel>>GetDepartmentPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) async {
    List<DepartmentModel> listModel = [];
    Map<String, String> param = {
      "searchType": searchType,
      "startIdx" : startIdx.toString(),
      "endIdx" : endIdx.toString()
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT_GET_PAGINATE);
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
          DepartmentModel _model =  DepartmentModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future <DepartmentModel> GetDepartmentById(String userId, String locId, String departmentId) async {
    DepartmentModel model;
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT + departmentId);
      var res = await http.get(
          url,
          headers: HEADER,
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        Map<String, dynamic> mapRes = jsonDecode(json[BODY]);
        model = DepartmentModel.map(mapRes);
        return model;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<DepartmentModel>>GetDepartmentByDescription(String userId, String locId, String description) async {
    List<DepartmentModel> listModel = [];
    Map<String, String> param = {
      "description": description,
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT_GET_BY_DESCRIPTION);
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
          DepartmentModel _model =  DepartmentModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool>AddDepartment(String userId, String locId, Map<String, String> param) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT_ADD);
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
  Future<bool>UpdateDepartment(String userId, String locId, Map<String, String> param) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + DEPARTMENT_UPDATE);
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
