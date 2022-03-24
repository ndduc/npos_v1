// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:npos/Constant/API/MapValues.dart';
import 'package:npos/Constant/API/NumberValues.dart';
import 'package:npos/Constant/API/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ApiModel/UpcPaginationModel.dart';
import 'package:http/http.dart' as http;
import 'package:npos/Model/UpcModel.dart';

abstract class Service{
  Future<UpcModel> GetByUpc(String userId, String locId, String productId, String upc);
  Future<UpcPaginationModel> GetUpcPaginate(String userId, String locId, String productId, String limit, String offset, String order);
  Future<bool> VerifyUpc(String userId, String locId, String productId, String upc);
  Future<bool> AddUpc(String userId, String locId, String productId, String upc);
  Future<bool> RemoveUpc(String userId, String locId, String productId, String upc);
}
class UpcService extends Service{
  @override
  Future<UpcModel> GetByUpc(String userId, String locId, String productId, String upc) async {
    try {
      var url =  Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + productId + UPC + upc + SLASH + GET);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        UpcModel responseModel = UpcModel.map(jsonDecode(json[BODY]));
        return responseModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<UpcPaginationModel> GetUpcPaginate(String userId, String locId, String productId, String limit, String offset, String order) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + productId + UPC_GET_PAGINATE
          + QUESTION + LIMIT + EQUAL + limit + AND + OFFSET + EQUAL + offset +  AND + ORDER + EQUAL + order );
      print(url);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        ConsolePrint("Response", json);
        UpcPaginationModel responseModel = UpcPaginationModel(jsonDecode(json[BODY]));
        return responseModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> VerifyUpc(String userId, String locId, String productId, String upc) async {
    try {
      var url =  Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + productId + UPC + upc + SLASH + VERIFY);
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        bool response = jsonDecode(json[BODY]);
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> AddUpc(String userId, String locId, String productId, String upc) async {
    Map<String, dynamic> body = {
      UPC_STR : upc
    };
    try {
      var url =  Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + productId + UPC_ADD);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName('utf-8'),
          body: body
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        bool response = jsonDecode(json[BODY]);
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> RemoveUpc(String userId, String locId, String productId, String upc) async {
    Map<String, dynamic> body = {
      UPC_STR : upc
    };
    try {
      var url =  Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + productId + UPC_REMOVE);
      var res = await http.post(
          url,
          headers: HEADER,
          encoding: Encoding.getByName('utf-8'),
          body: body
      );
      ConsolePrint("URL DELETE UPC", url);
      ConsolePrint("URL DELETE UPC RES", res.body);
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        bool response = jsonDecode(json[BODY]);
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }
}