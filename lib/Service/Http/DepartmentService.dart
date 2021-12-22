// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String HOST ="https://192.168.1.2:5001/";
  String MAIN_ENDPOINT = "api/pos/";
  String confirm = "OK";
  @override
  Future<List<DepartmentModel>>GetDepartments(String userId, String locId) async {
    List<DepartmentModel> listModel = [];
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/get");
      var res = await http.get(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          }
      );
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        List<dynamic> lstRes = jsonDecode(json["body"]);
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
  Future<int> GetDepartmentPaginateCount(String userId, String locId, String searchType) async {
    ConsolePrint("GetDepartmentPaginateCount", "TEST");
    Map<String, String> param = {
      "searchType" : searchType
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/get-count");
      var res = await http.post(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: param
      );
      List<LocationModel> locationList = [];
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        int response = jsonDecode(json["body"]);
        ConsolePrint("GetProductPaginateCount", response);
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<DepartmentModel>>GetDepartmentPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) async {
    ConsolePrint("GetDepartmentPaginateByIndex", "TEST");
    List<DepartmentModel> listModel = [];
    Map<String, String> param = {
      "searchType": searchType,
      "startIdx" : startIdx.toString(),
      "endIdx" : endIdx.toString()
    };
    ConsolePrint("TEST\t\t", param);

    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/get-department-paginate");
      var res = await http.post(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: param
      );
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);

        List<dynamic> lstRes = jsonDecode(json["body"]);
        for(int i = 0; i < lstRes.length; i++) {
          DepartmentModel _model =  DepartmentModel.map(lstRes[i]);
          listModel.add(_model);
        }
        ConsolePrint("GetDepartmentPaginateByIndex", listModel);
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future <DepartmentModel> GetDepartmentById(String userId, String locId, String departmentId) async {
    ConsolePrint("GetDepartmentById", "Test");
    DepartmentModel model;
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/" + departmentId);
      var res = await http.get(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          }
      );
      List<LocationModel> locationList = [];
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        Map<String, dynamic> mapRes = jsonDecode(json["body"]);
        ConsolePrint("RES", mapRes);
        model = DepartmentModel.map(mapRes);
        return model;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<DepartmentModel>>GetDepartmentByDescription(String userId, String locId, String description) async {
    ConsolePrint("GetDepartmentByDescription", description);
    List<DepartmentModel> listModel = [];
    Map<String, String> param = {
      "description": description,
    };
    ConsolePrint("TEST\t\t", param);

    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/get-by-description");
      var res = await http.post(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: param
      );
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        ConsolePrint("JSON", json);
        List<dynamic> lstRes = jsonDecode(json["body"]);
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
    ConsolePrint("AddDepartment", "TEST");
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/add");
      var res = await http.post(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: param
      );
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        String response = json["body"];
        if (response == confirm) {
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
    ConsolePrint("UpdateDepartment", "TEST");
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/department/update");
      var res = await http.post(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: param
      );
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        ConsolePrint("TEST RES", json);
        String response = json["body"];
        if (response == confirm) {
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

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
//https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/