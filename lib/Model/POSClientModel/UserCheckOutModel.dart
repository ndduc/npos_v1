import 'package:npos/Model/UserModel.dart';

class UserCheckOutModel extends UserModel {
  /// these variable will keeping track all user action in the order
  List<String> addedItems = [];
  List<String> voidedItems = [];
  List<String> refundedItems = [];
  List<String> discountGiven = [];
}