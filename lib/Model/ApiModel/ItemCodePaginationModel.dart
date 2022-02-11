import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ItemCodeModel.dart';

import 'PaginationModel.dart';

class ItemCodePaginationModel {
  PaginationModel paginationModel = PaginationModel();
  List<ItemCodeModel> itemCodeList = [];

  ItemCodePaginationModel.empty() {
    paginationModel = PaginationModel();
    itemCodeList = [];
  }
  ItemCodePaginationModel(Map<String, dynamic> response) {
    paginationModel = PaginationModel.map(response["PaginationObject"]);
    List<dynamic> tmpItemCodeList = response["ItemCodeList"];
    List<ItemCodeModel> itemList = [];
    for(int i = 0; i < tmpItemCodeList.length; i++) {
      ItemCodeModel model = ItemCodeModel.map(tmpItemCodeList[i]);
      itemList.add(model);
    }

    if (itemList.isNotEmpty) {
      itemCodeList = itemList;
    }
  }

  print() {
    ConsolePrint("Count", paginationModel.Count);
    ConsolePrint("OffSet", paginationModel.OffSet);
    ConsolePrint("Limit", paginationModel.Limit);
    ConsolePrint("Order", paginationModel.Order);
    for(int i = 0; i < itemCodeList.length; i++) {
      ConsolePrint("itemCode", itemCodeList[i].itemCode);
    }

  }
}