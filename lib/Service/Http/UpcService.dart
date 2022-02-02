// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names



import 'package:npos/Model/ApiModel/UpcPaginationModel.dart';
import 'package:npos/Model/UpcModel.dart';

abstract class Service{
  Future<UpcModel> GetByUpc(String userId, String locId, String productId, String Upc);
  Future<UpcPaginationModel> GetUpcPaginate(String userId, String locId, String productId);
  Future<bool> VerifyUpc(String userId, String locId, String productId, String Upc);
  Future<bool> AddUpc(String userId, String locId, String productId, String Upc);
  Future<bool> RemoveUpc(String userId, String locId, String productId, String Upc);
}
class UpcService extends Service{
  @override
  Future<UpcModel> GetByUpc(String userId, String locId, String productId, String Upc) {
    dynamic res;
    return res;
  }

  @override
  Future<UpcPaginationModel> GetUpcPaginate(String userId, String locId, String productId) {
    dynamic res;
    return res;
  }

  @override
  Future<bool> VerifyUpc(String userId, String locId, String productId, String Upc) {
    dynamic res;
    return res;
  }

  @override
  Future<bool> AddUpc(String userId, String locId, String productId, String Upc) {
    dynamic res;
    return res;
  }

  @override
  Future<bool> RemoveUpc(String userId, String locId, String productId, String Upc) {
    dynamic res;
    return res;
  }
}