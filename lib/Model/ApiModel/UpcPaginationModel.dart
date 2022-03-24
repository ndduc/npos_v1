import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ItemCodeModel.dart';

import '../UpcModel.dart';
import 'PaginationModel.dart';

class UpcPaginationModel {
  PaginationModel paginationModel = PaginationModel();
  List<UpcModel> upcList = [];

  UpcPaginationModel.empty() {
    paginationModel = PaginationModel();
    upcList = [];
  }
  UpcPaginationModel(Map<String, dynamic> response) {
    paginationModel = PaginationModel.map(response["PaginationObject"]);
    List<dynamic> tmpUpcList = response["UpcList"];
    List<UpcModel> itemList = [];
    for(int i = 0; i < tmpUpcList.length; i++) {
      UpcModel model = UpcModel.map(tmpUpcList[i]);
      model.print();
      itemList.add(model);
    }

    if (itemList.isNotEmpty) {
      upcList = itemList;
    }
  }

  print() {
    ConsolePrint("Count", paginationModel.Count);
    ConsolePrint("OffSet", paginationModel.OffSet);
    ConsolePrint("Limit", paginationModel.Limit);
    ConsolePrint("Order", paginationModel.Order);
    for(int i = 0; i < upcList.length; i++) {
      ConsolePrint("itemCode", upcList[i].upc);
    }

  }
}