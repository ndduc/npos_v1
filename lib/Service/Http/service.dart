
import 'package:http/http.dart' as http;
import 'package:npos/Model/user.dart';

abstract class ServiceApi{
  Future<List<Albums>>getAlbums();

}

class AlbumService extends ServiceApi{
  String BASE_URL="https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/";
  //String ALBUMS="/albums";
  @override
  Future<List<Albums>> getAlbums() async{

    try {
      var uri = Uri.parse(BASE_URL);
      var response = await http.get(
          uri, headers: {"ContentType": "application/json"});
      var albumslist = albumsFromJson(response.body);

      return albumslist;
    } catch(e){

      return List<Albums>.empty();
    }
  }

}

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
//https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/