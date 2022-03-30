import 'package:npos/Debug/Debug.dart';

import '../UserRelationModel.dart';
import '../LocationModel.dart';
class UserPaginationModel {
  int count = 0;
  int startIndex = -1;
  int endIndex = -1;
  List<UserRelationModel> userRelationModels = [];

  print() {
    ConsolePrint("Data Count", count);
  }
  UserPaginationModel.fromJson(Map<String, dynamic> response) {
    List<dynamic> dataObject = response["DataObject"];
    userRelationModels = [];
    count = response["Count"];
    startIndex = response["StartIndex"];
    endIndex = response["EndIndex"];
    for(int i = 0; i < dataObject.length; i++) {
      UserRelationModel model = UserRelationModel();
      List<String> locationIdList = List<String>.from(dataObject[i]["LocationIds"] as List);
      List<dynamic> userLocationList = dataObject[i]["UserLocations"];  // each item to be parsed to LocationModel
      
      model.locationIds = locationIdList;
      model.uid = dataObject[i]["UId"];
      model.userName = dataObject[i]["UserName"];
      model.password = dataObject[i]["Password"];
      model.firstName = dataObject[i]["FirstName"];
      model.lastName = dataObject[i]["LastName"];
      model.email = dataObject[i]["Email"];
      model.email2 = dataObject[i]["Email2"];
      model.phone = dataObject[i]["Phone"];
      model.address = dataObject[i]["Address"];
      model.addedDateTime = dataObject[i]["AddedDateTime"];
      model.updatedDateTime = dataObject[i]["UpdatedDateTime"];
      model.addedBy = dataObject[i]["AddedBy"];
      model.updatedBy = dataObject[i]["UpdatedBy"];
      model.isAuthorized = true; // set to true because this model has nothing to with app authorization
      model.userType = dataObject[i]["UserType"];

      model.userLocations = [];
      for(int i = 0; i < userLocationList.length; i++) {
        LocationModel locationModel = LocationModel.mapJsonStyle2(userLocationList[i]);
        model.userLocations.add(locationModel);
      }
      userRelationModels.add(model);
    }
  }
}