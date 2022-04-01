import 'package:npos/Model/POSClientModel/ProductCheckOutModel.dart';

import '../LocationModel.dart';
import 'UserCheckOutModel.dart';

/// Consisting a list of ProductCheckoutModel



class ProductOrderModel {
  /// Uid will be system unique id
  late int orderUId;
  /// Id will be human readable Id, starting from 0 per location
  late int orderId;

  late DateTime orderAddDateTime;
  late DateTime orderUpdateDateTime;

  /// The goal here is to store product UID as key and Checkout Object as Value
  /// There will be 3 different kind of KEY
  /// UID_PURCHASE as item to be purchase by customer
  /// UID_VOID as item voided from existing order
  /// UID_REFUND as item refunded from existing order
  Map<String, ProductCheckOutModel> transaction = {};
  double orderSubTotal = 0.0;
  double orderQuantity = 0.0;
  double orderTotalTax = 0.0;
  double orderTotalRefund = 0.0;
  double orderTotalDiscount = 0.0;

  double orderSubTotalStep1 = 0.0;  /// Step 1 including, subTotal, TotalTax
  double orderSubTotalStep2 = 0.0;  /// Step 1 including, subTotal, totalDiscount, TotalTax
  double orderSubTotalStep3 = 0.0;  /// Step 1 including, subTotal, totalDiscount, totalRefund, TotalTax

  double totalVoidByQuantity = 0.0;
  double totalVoidByPrice = 0.0;

  List<UserCheckOutModel> orderInvolveUser = [];
  List<LocationModel> orderLocation = [];
}