import 'package:npos/Constant/Values/StringValues.dart';
import 'package:npos/Model/ProductModel.dart';

class ProductCheckOutModel extends ProductModel{
  String productModelId = "";
  /// quantity as total number of the same item added to current order
  double quantity = 0;
  /// tax as total tax of the same item added to current order
  double totalTax = 0.0;
  /// subTotal as total price of the same item added to current order
  double subTotal = 0.0;
  /// transaction as PURCHASE, VOID, OR REFUND
  /// each of these type will have it own logic
  String transactionType = "";
}