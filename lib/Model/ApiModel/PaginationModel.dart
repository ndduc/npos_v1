class PaginationModel {
  int? Limit;
  int? OffSet;
  int? Count;
  String? Order;

  PaginationModel() {}
  PaginationModel.map(Map<String, dynamic> map) {
    Limit = map["Limit"];
    OffSet = map["OffSet"];
    Count = map["Count"];
    Order = map["Order"];
  }
}