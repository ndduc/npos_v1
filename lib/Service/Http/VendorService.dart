// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/VendorModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';

abstract class Service{
  Future<List<VendorModel>> GetVendor(String userId, String locId);  // Just a simple get all
  Future<VendorModel> GetVendorById(String userId, String locId, String vendorId);
  Future<int>GetVendorPaginateCount(String userId, String locId, String searchType);
  Future<List<VendorModel>>GetVendorPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx);
  Future<List<VendorModel>>GetVendorByDescription(String userId, String locId, String description);
  Future<bool>AddVendor(String userId, String locId, Map<String, String> param);
  Future<bool>UpdateVendor(String userId, String locId, Map<String, String> param);
}
class VendorService extends Service{
  String HOST ="https://192.168.1.2:5001/";
  String MAIN_ENDPOINT = "api/pos/";
  String confirm = "OK";
  @override
  Future<List<VendorModel>>GetVendor(String userId, String locId) async {
    List<VendorModel> listModel = [];
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/get");
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
          VendorModel _model =  VendorModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> GetVendorPaginateCount(String userId, String locId, String searchType) async {
    Map<String, String> param = {
      "searchType" : searchType
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/get-count");
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
        int response = jsonDecode(json["body"]);
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<VendorModel>>GetVendorPaginateByIndex(String userId, String locId, String searchType, int startIdx, int endIdx) async {
    List<VendorModel> listModel = [];
    Map<String, String> param = {
      "searchType": searchType,
      "startIdx" : startIdx.toString(),
      "endIdx" : endIdx.toString()
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/get-vendor-paginate");
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
          VendorModel _model =  VendorModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future <VendorModel> GetVendorById(String userId, String locId, String vendorId) async {
    VendorModel model;
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/" + vendorId);
      var res = await http.get(
          url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          }
      );
      List<VendorModel> locationList = [];
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        Map<String, dynamic> mapRes = jsonDecode(json["body"]);
        model = VendorModel.map(mapRes);
        return model;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<VendorModel>>GetVendorByDescription(String userId, String locId, String description) async {
    List<VendorModel> listModel = [];
    Map<String, String> param = {
      "description": description,
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/get-by-vendor");
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
          VendorModel _model =  VendorModel.map(lstRes[i]);
          listModel.add(_model);
        }
        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool>AddVendor(String userId, String locId, Map<String, String> param) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/add");
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
  Future<bool>UpdateVendor(String userId, String locId, Map<String, String> param) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/vendor/update");
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
}