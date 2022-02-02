// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Model/ApiModel/ItemCodePaginationModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';

abstract class Service{
  Future<ItemCodeModel> GetByItemCode(String userId, String locId, String productId, String itemCode);
  Future<ItemCodePaginationModel> GetItemCodePaginate(String userId, String locId, String productId);
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
  Future<ItemCodePaginationModel> GetItemCodePaginate(String userId, String locId, String productId) {
    dynamic res;
    return res;
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