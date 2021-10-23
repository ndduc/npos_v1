
import 'package:npos/Model/user.dart';
import 'package:npos/Service/Http/service.dart';
class Albumsrepository{

  Future<List<Albums>>getAlbumsList(){

    return AlbumService().getAlbums();
  }
}