// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';

abstract class Service{
  Future<ProductModel>GetProductByMap(String userId, String locId, Map<String, String> param);
}
class ProductService extends Service{
  String HOST ="https://192.168.1.2:5001/";
  String MAIN_ENDPOINT = "api/pos/";
  @override
  Future<ProductModel> GetProductByMap(String userId, String locId, Map<String, String> param) async {
    ProductModel model;
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/product/get-by-map");
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
        Map<String, dynamic> mapRes = jsonDecode(json["body"]);
        ConsolePrint("RES", mapRes);
        model = ProductModel.map(mapRes);
        model.print();
        return model;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

}

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
//https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/