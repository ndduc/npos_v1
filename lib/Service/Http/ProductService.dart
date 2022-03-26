// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/AddResponseModel.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/ProductModel.dart';

abstract class Service{
  Future<ProductModel>GetProductByMap(String userId, String locId, Map<String, dynamic> param);
  Future<int>GetProductPaginateCount(String userId, String locId, Map<String, dynamic> optionalParameter);
  Future<List<ProductModel>>GetProductPaginateByIndex(String userId, String locId, Map<String, dynamic> optionalParameter);
  Future<AddResponseModel> AddProduct(ProductModel productMode,  String locationIdl);
  Future<AddResponseModel> UpdateProduct(ProductModel productModel, String locationId);
}
class ProductService extends Service{
  String HOST ="https://192.168.1.2:5001/";
  String MAIN_ENDPOINT = "api/pos/";

  @override
  Future<AddResponseModel> AddProduct(ProductModel productModel, String locationId) async {
    Map<String, dynamic> param = <String, dynamic>{
      "description" : productModel.description.toString(),
      "second_description" : productModel.second_description.toString(),
      "third_description" : productModel.third_description.toString(),
      "cost" : productModel.cost.toString(),
      "price": productModel.price.toString()
    };
    param["departmentList"] = json.encode(productModel.departmentList);
    param["categoryList"] = json.encode(productModel.categoryList);
    param["vendorList"] = json.encode(productModel.vendorList);
    param["sectionList"] = json.encode(productModel.sectionList);
    param["discountList"] = json.encode(productModel.discountList);
    param["taxList"] = json.encode(productModel.taxList);
    param["itemCodeList"] = json.encode(productModel.itemCodeList);
    param["upcList"] = json.encode(productModel.upcList);
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + productModel.added_by.toString() + "/" + locationId + "/product/add");
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
        Map<String, dynamic> mapRes = jsonDecode(json["body"]);
        AddResponseModel model = AddResponseModel.map(mapRes);
        return model;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AddResponseModel> UpdateProduct(ProductModel productModel, String locationId) async {
    Map<String, dynamic> param = <String, dynamic>{
      "uid" : productModel.uid.toString(),
      "description" : productModel.description.toString(),
      "second_description" : productModel.second_description.toString(),
      "third_description" : productModel.third_description.toString(),
      "cost" : productModel.cost.toString(),
      "price": productModel.price.toString()
    };
    param["departmentList"] = json.encode(productModel.departmentList);
    param["categoryList"] = json.encode(productModel.categoryList);
    param["vendorList"] = json.encode(productModel.vendorList);
    param["sectionList"] = json.encode(productModel.sectionList);
    param["discountList"] = json.encode(productModel.discountList);
    param["taxList"] = json.encode(productModel.taxList);
    param["itemCodeList"] = json.encode(productModel.itemCodeList);
    param["upcList"] = json.encode(productModel.upcList);


    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + productModel.added_by.toString() + "/" + locationId + "/product/update");
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
        Map<String, dynamic> mapRes = jsonDecode(json["body"]);
        AddResponseModel model = AddResponseModel.map(mapRes);
        return model;
      }
    } catch (e) {
      throw Exception(e);
    }
  }


  @override
  Future<ProductModel> GetProductByMap(String userId, String locId, Map<String, dynamic> param) async {
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
      if(res.statusCode != 200) {
        throw Exception(res.body.toString());
      } else {

        var json = jsonDecode(res.body);
        ConsolePrint("RES", jsonDecode(json["body"]));
        if (jsonDecode(json["body"]) == null)  {
          model = ProductModel();
          model.isEmpty = true;
        } else {
          Map<String, dynamic> mapRes = jsonDecode(json["body"]);
          model = ProductModel.map(mapRes);
        }
        return model;
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  @override
  Future<int>GetProductPaginateCount(String userId, String locId, Map<String, dynamic> optionalParameter) async {
    print(optionalParameter);
    Map<String, String> param = {};
    if(optionalParameter["searchText"].toString().isNotEmpty) {
      param["searchText"] =  optionalParameter["searchText"];
    } else {
      param["searchText"] =  "";
    }

    if(optionalParameter["uid"].toString().isNotEmpty) {
      param["uid"] =  optionalParameter["uid"];
    } else {
      param["uid"] =  "";
    }

    if(optionalParameter["itemCode"].toString().isNotEmpty) {
      param["itemCode"] =  optionalParameter["itemCode"];
    } else {
      param["itemCode"] =  "";
    }

    if(optionalParameter["upc"].toString().isNotEmpty) {
      param["upc"] =  optionalParameter["upc"];
    } else {
      param["upc"] =  "";
    }

    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/product/get-count");
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
  Future<List<ProductModel>>GetProductPaginateByIndex(String userId, String locId, Map<String, dynamic> optionalParameter) async {
    print(optionalParameter);
    List<ProductModel> listModel = [];
    Map<String, String> param = {
      "startIdx" : optionalParameter["startIdx"].toString(),
      "endIdx" : optionalParameter["endIdx"].toString(),
    };

    if(optionalParameter["searchText"].toString().isNotEmpty) {
      param["searchText"] =  optionalParameter["searchText"];
    } else {
      param["searchText"] =  "";
    }

    if(optionalParameter["uid"].toString().isNotEmpty) {
      param["uid"] =  optionalParameter["uid"];
    } else {
      param["uid"] =  "";
    }

    if(optionalParameter["itemCode"].toString().isNotEmpty) {
      param["itemCode"] =  optionalParameter["itemCode"];
    } else {
      param["itemCode"] =  "";
    }

    if(optionalParameter["upc"].toString().isNotEmpty) {
      param["upc"] =  optionalParameter["upc"];
    } else {
      param["upc"] =  "";
    }

    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/" + locId + "/product/get-product-paginate");
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
          ProductModel _model =  ProductModel.map(lstRes[i]);
          listModel.add(_model);
        }

        return listModel;
      }
    } catch(e) {
      throw Exception(e);
    }
  }
}

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
//https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/