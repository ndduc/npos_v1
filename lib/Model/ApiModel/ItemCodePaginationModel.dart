import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ItemCodeModel.dart';

import 'PaginationModel.dart';

class ItemCodePaginationModel {
  PaginationModel? paginationModel;
  List<ItemCodeModel>? itemCodeList;

  ItemCodePaginationModel.empty() {
    paginationModel = PaginationModel();
    itemCodeList = [];
  }
  ItemCodePaginationModel(Map<String, dynamic> response) {
    paginationModel = PaginationModel.map(response["PaginationObject"]);
    List<dynamic> itemCodeList = response["ItemCodeList"];
    List<ItemCodeModel> itemList = [];
    for(int i = 0; i < itemCodeList.length; i++) {
      ItemCodeModel model = ItemCodeModel.map(itemCodeList[i]);
      itemList.add(model);
    }
  }
}