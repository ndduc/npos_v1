// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Service/Http/ProductService.dart';
import 'package:npos/Service/Http/UserService.dart' ;
import 'package:npos/Service/Http/LocationService.dart' ;

class MainRepository{

  Future<UserModel> AuthorizingUser(String name, String password) {
    return UserService().AuthorizingUser(name, password);
  }

  Future<List<LocationModel>> GetLocationByUser(String uid) {
    return LocationService().GetLocationByUser(uid);
  }

  Future<ProductModel> GetProductByParamMap(String userId, String locId, Map<String, String> param) {
    return ProductService().GetProductByMap(userId, locId, param);
  }
}