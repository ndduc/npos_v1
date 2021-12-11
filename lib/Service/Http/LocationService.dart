// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/LocationModel.dart';

abstract class Service{
  Future<List<LocationModel>>GetLocationByUser(String userId);
}
class LocationService extends Service{
  String HOST ="https://192.168.1.2:5001/";
  String MAIN_ENDPOINT = "api/pos/";
  @override
  Future<List<LocationModel>> GetLocationByUser(String userId) async {
    try {
      var url = Uri.parse(HOST + MAIN_ENDPOINT + userId + "/location");
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
        List<dynamic> lstTmp = json["body"];
        if(lstTmp.isNotEmpty) {
          bool isError = lstTmp[0]["isError"];
          if(isError) {
            return locationList;
          } else {
            for(int i = 0; i < lstTmp.length; i++) {
             LocationModel locationModel = LocationModel.map(lstTmp[i]);
             locationList.add(locationModel);
            }
            return locationList;
          }
        } else {
          return locationList;
        }

      }
    } catch(e) {
      throw Exception(e);
    }
  }

}

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
//https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/