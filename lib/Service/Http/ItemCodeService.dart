// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:npos/Constant/API/MapValues.dart';
import 'package:npos/Constant/API/NumberValues.dart';
import 'package:npos/Constant/API/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ApiModel/ItemCodePaginationModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:http/http.dart' as http;

abstract class Service{
  Future<ItemCodeModel> GetByItemCode(String userId, String locId, String productId, String itemCode);
  Future<ItemCodePaginationModel> GetItemCodePaginate(String userId, String locId, String productId, String limit, String offset, String order);
  Future<bool> VerifyItemCode(String userId, String locId, String productId, String ItemCode);
  Future<bool> AddItemCode(String userId, String locId, String productId, String ItemCode);
  Future<bool> RemoveItemCode(String userId, String locId, String productId, String ItemCode);
}
class ItemCodeService extends Service{
  @override
  Future<ItemCodeModel> GetByItemCode(String userId, String locId, String productId, String itemCode) {
    dynamic res;
    return res;
  }

  @override
  Future<ItemCodePaginationModel> GetItemCodePaginate(String userId, String locId, String productId, String limit, String offset, String order) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + SLASH + locId + SLASH + productId + ITEMCODE_GET_PAGINATE
          + QUESTION + LIMIT + EQUAL + limit + AND + OFFSET + EQUAL + offset +  AND + ORDER + EQUAL + order );
      var res = await http.get(
          url,
          headers: HEADER
      );
      if(res.statusCode != STATUS_OK) {
        throw Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        ItemCodePaginationModel responseModel = ItemCodePaginationModel(jsonDecode(json[BODY]));
        return responseModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> VerifyItemCode(String userId, String locId, String productId, String ItemCode) {
    dynamic res;
    return res;
  }

  @override
  Future<bool> AddItemCode(String userId, String locId, String productId, String ItemCode) {
    dynamic res;
    return res;
  }

  @override
  Future<bool> RemoveItemCode(String userId, String locId, String productId, String ItemCode) {
    dynamic res;
    return res;
  }
}