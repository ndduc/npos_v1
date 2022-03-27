import 'LocationModel.dart';
import 'UserModel.dart';

class UserRelationModel extends UserModel {
  UserRelationModel() : super();
  List<String> locationIds = [];
  List<LocationModel> userLocations = [];
}