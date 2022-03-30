// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ApiModel/UserPaginationModel.dart';
import 'package:npos/Model/UserModel.dart';

abstract class Service{
  Future<UserModel>AuthorizingUser(String user, String password);
  Future<UserPaginationModel> GetUserPagination(String userId, String locationId, Map<String, dynamic> optionalParameter);
}
class UserService extends Service{
  String HOST ="https://192.168.1.2:5001/";
  String MAIN_ENDPOINT = "api/pos/";
  @override
  Future<UserModel> AuthorizingUser(String user, String password) async {
    Map<dynamic, dynamic> param() => {
      'user': user,
      'pass': password
    };
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + "user/authorize");
      var res = await http.post(
          url, 
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: param()
      );
      if(res.statusCode != 200) {
        throw new Exception(res.body.toString());
      } else {
        var json = jsonDecode(res.body);
        Map<String, dynamic> decodedJson = jsonDecode(json["body"]);
        UserModel userModel = UserModel.fromMap(decodedJson);
        return userModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserPaginationModel> GetUserPagination(String userId, String locationId, Map<String, dynamic> optionalParameter) async {
    Map<String, String> param = {};
    if(optionalParameter["startIdx"].toString().isNotEmpty) {
      param["startIdx"] =  optionalParameter["startIdx"];
    } else {
      param["startIdx"] =  "-1";
    }

    if(optionalParameter["endIdx"].toString().isNotEmpty) {
      param["endIdx"] =  optionalParameter["endIdx"];
    } else {
      param["endIdx"] =  "-1";
    }

    if(optionalParameter["userFullName"].toString().isNotEmpty) {
      param["userFullName"] =  optionalParameter["userFullName"];
    } else {
      param["userFullName"] =  "";
    }

    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locationId + "/user/get-user-pagination");
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
        UserPaginationModel response = UserPaginationModel.fromJson(jsonDecode(json["body"]));
        return response;
      }
    } catch(e) {
      throw Exception(e);
    }
  }
}

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
//https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/