// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/Dummy/DummyValues.dart';
import 'package:npos/Constant/UI/Product/ProductShareUIValues.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UIEvent/addProductEvent.dart';
import 'package:npos/Constant/UIEvent/menuEvent.dart';
import 'package:npos/Constant/Values/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/DiscountModel.dart';
import 'package:npos/Model/POSClientModel/ProductCheckOutModel.dart';
import 'package:npos/Model/POSClientModel/ProductOrderModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:virtual_keyboard/virtual_keyboard.dart';

// ignore: must_be_immutable
class MainClientBody extends StatefulWidget {
  UserModel? userData;
  MainClientBody({Key? key, this.userData}) : super(key: key);

  @override
  _MainClientBody createState() => _MainClientBody();
}

class _MainClientBody extends State<MainClientBody> {

  ProductOrderModel productOrder = ProductOrderModel();
  String loadEvent = EMPTY;
  List<DiscountModel> discounts = <DiscountModel>[];
  @override
  void initState() {
    super.initState();
    initProductOrderTesting();
  }

  void initProductOrderTesting() {
    productOrder.orderUId = 1;
    productOrder.orderId = 1;
    productOrder.orderAddDateTime = DateTime.now();
    productOrder.orderUpdateDateTime = DateTime.now();
    productOrder.transaction = [];

    ProductCheckOutModel tempProd1 = ProductCheckOutModel();
    tempProd1.uid = "PRODUCT_123";
    tempProd1.description = "TEST PRODUCT";
    tempProd1.cost = 1.00;
    tempProd1.price = 5.00;
    tempProd1.subTotal = 5.00;
    tempProd1.quantity = 1;
    tempProd1.transactionType = PURCHASE;
    tempProd1.productModelId = tempProd1.transactionType + "_" + tempProd1.uid!;

    productOrder.transaction.add(tempProd1);
    productOrder.orderSubTotal = 5.00;
    productOrder.orderQuantity = 1;
    productOrder.orderTotalTax = 0.05;

    productOrder.orderInvolveUser = [];
    productOrder.orderLocation = [];
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body:
          BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
            /**
             * BLoc Action Note
             * START
             * */
            appBaseEvent(state);
            appSpecificEvent(state);
            appCheckoutItemEvent(state);
            appDiscountEvent(state);
            appPaymentEvent(state);
            appItemEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return mainBody();
          })

      ),
    );
  }

  Widget mainBody() {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: bodyCheckOut(),
            ),
            Expanded(
              flex: 4,
              child: bodyInput(),
            ),
            Expanded(
              flex: 2,
              child: bodyOption(),
            )
          ],
        ),
        /// KEYBOARD
        //displayKeyboard(),
      ],

    ) ;
  }

  void appBaseEvent(MainState state) {
    // Executing Generic State
    if (state is GenericInitialState) {
      // isLoading = false;
    } else if (state is GenericLoadingState) {
      // isLoading = true;
    } else if (state is GenericErrorState) {
      // isLoading = false;
      // context.read<MainBloc>().add(MainParam.showSnackBar(eventStatus: MainEvent.Show_SnackBar, context: context, snackBarContent: state.error.toString()));
    }
  }

  void appSpecificEvent(MainState state) {
    // Executing Specific State
  }

  void appCheckoutItemEvent(MainState state) {
    if (state is CheckoutItemInit) {

    } else if (state is CheckoutItemLoading) {

    } else if (state is CheckoutItemLoaded) {
      this.productOrder = state.productOrderModel!;
    } else if (state is CheckoutItemError) {

    }
  }

  void appDiscountEvent(MainState state) {
    if (state is DiscountPaginateLoadingState) {

    } else if (state is DiscountPaginateLoadedState) {
      ConsolePrint("Discount", state.listDiscountModel?.length);
      discounts = state.listDiscountModel ?? <DiscountModel>[];
      loadEvent = OPTION_DISCOUNT;
    }
  }

  void appPaymentEvent(MainState state) {
    if (state is CheckoutPaymentsInit) {

    } else if (state is CheckoutPaymentsLoading) {

    } else if (state is CheckoutPaymentsLoaded) {
      loadEvent = OPTION_PAYMENT;
    } else if (state is CheckoutPaymentsError) {

    }
  }

  void appItemEvent(MainState state) {
    if (state is CheckoutItemsInit) {

    } else if (state is CheckoutItemsLoading) {

    } else if (state is CheckoutItemsLoaded) {
      loadEvent = OPTION_ITEM;
    } else if (state is CheckoutItemsError) {

    }
  }

  Widget bodyCheckOut() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 8,
                child: // Text("TEST 4-1"),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  /// Depend on business, this input will be updated accordingly
                  /// example: grocery then it will be UPC
                  ///          service model then it will be some kind of user defined code
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: "Scan or Enter Item Upc",
                      hintText: "Hint",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),

                )

            ),
            Expanded(
                flex: 2,
                child: // Text("TEST 4-1"),
                solidButton(BTN_CONFIRM, EVENT_CONFIRM)

            ),
          ],
        ),

        Expanded(
          flex: 8,
          child: //Text("TEST 4-8"),
          Container(
            child: ListView.builder(
              itemCount: productOrder.transaction.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                      title:Container(
                        child: Row (
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(productOrder.transaction[index].description.toString()),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text("\$" + productOrder.transaction[index].subTotal.toString()),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Text("CODE SEQ."),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        flex: 7,
                                        child: SizedBox(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(productOrder.transaction[index].quantity.toString() + " Unit * " + productOrder.transaction[index].price.toString()),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex:2,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        /// Void Logic On Selected Item
                                        /// Logic Overview
                                        /// If Quantity is greater than 1, then pop option for user to void a specific number of item
                                        /// If Quantity By Weight then simply void the entire item
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        /// Edit button allow user to do these following option. Pop up occur upon selected
                                        /// Change quantity (unit only, no weight)
                                        /// Perform Price Override
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: IconButton(
                                      icon: const Icon(Icons.money),
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        /// Allow user to add discount to specific item
                                      },
                                    ),
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      ) ,
                      onTap: () {
                        ConsolePrint("LIST", "CLICKED");
                      },
                    )
                );
              },
              padding: EdgeInsets.all(10),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
          )
        ),
        Expanded(
          flex: 1,
          child:Container(
            child: Card(
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Number of Voided Item: " + productOrder.totalVoidByQuantity.toString()
                          ),
                          Text(
                              "Amount of Voided Item: \$" + productOrder.totalVoidByPrice.toString()
                          ),
                          Text(
                              "Number of Refunded Item: " + productOrder.orderTotalRefundQuantity.toString()
                          ),
                          Text(
                              "Amount of Refunded Item: \$" + productOrder.orderTotalRefund.toString()
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Sub Total: \$" + productOrder.orderSubTotal.toString()
                          ),
                          Text(
                              "Total Count: " + productOrder.orderQuantity.toString()
                          ),
                          Text(
                              "Total Tax: " + productOrder.orderTotalTax.toString()
                          ),
                          Text(
                              "Total Discount: " + productOrder.orderTotalDiscount.toString()
                          ),
                          Text(
                              "Total Amount: " + productOrder.orderSubTotalStep3.toString()
                          )
                        ],
                      )
                  )
                ],
              )
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
          ),
        )
      ]
    );
  }

  Widget bodyInput() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: optionItemTop(),
          )
        )  ,
        Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child:
                    showItemGrid()
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        children: [
                          Text("TEST")
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        border: Border.all(color: Colors.blueAccent),
                      )
                    )
                  )
                ],
              ),
            )
        )
      ],
    );
  }

  ///GRID HOLDS STUFFS LIKE ITEM FROM OPTION SUCH AS DISCOUNT HOLDS HOLD DISCOUNT_1, _2, _3,..etc
  //region GRID VIEW
  Widget showItemGrid() {
    // loadEvent
    return Container(
        child: gridProcessing(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(color: Colors.blueAccent),
        )
    );
  }

  Widget gridProcessing() {
    switch (loadEvent) {
      case EMPTY:
        return defaultGrid();
      case OPTION_DISCOUNT:
        return discountGrid();
      case OPTION_PAYMENT:
        return paymentGrid();
      case OPTION_ITEM:
        return itemGrid();
      default:
        return defaultGrid();
    }
  }

  Widget defaultGrid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.amber,
            child: Center(child: Text('$index')),
          );
        }
    );
  }

  Widget discountGrid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: discounts.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.amber,
            child: Center(child: Text(discounts[index].description!)),
          );
        }
    );
  }

  Widget paymentGrid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: dummyPayment.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.amber,
            child: Center(child: Text(dummyPayment[index]["name"])),
          );
        }
    );
  }

  Widget itemGrid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: dummyItem.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.amber,
            child: Center(child: Text(dummyItem[index]["name"])),
          );
        }
    );
  }

  //endregion

  ///KEYBOARD STUFF
  //region KEYBOARD

  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = true;

  /// We are going to cum back to this later
  /// Incorporate this widget with an event, where the keyboard will display upon a click event
  Widget displayKeyboard() {
    /// Align would allow this to display at specific area in stack
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          Text(
            text,

          ),
          SwitchListTile(
            title: Text(
              'Keyboard Type = ' +
                  (isNumericMode
                      ? 'VirtualKeyboardType.Numeric'
                      : 'VirtualKeyboardType.Alphanumeric'),
            ),
            value: isNumericMode,
            onChanged: (val) {
              setState(() {
                isNumericMode = val;
              });
            },
          ),
          // Expanded(
          //   child: Container(),
          // ),
          Container(
            color: Colors.deepPurple,
            child: VirtualKeyboard(
                height: 300,
                textColor: Colors.white,
                type: isNumericMode
                    ? VirtualKeyboardType.Numeric
                    : VirtualKeyboardType.Alphanumeric,
                onKeyPress: _onKeyPress),
          )
        ],
      )
    );
  }
  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }

  //endregion

  Widget bodyOption() {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: UserCard(userData: widget.userData),
            )
        )  ,
        Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: optionItem(),
            )
        )
      ],
    );
  }


  Widget optionItem() {
    return SingleChildScrollView(
        child:  SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            childAspectRatio: 3,
            scrollDirection: Axis.vertical,
            crossAxisCount: 1 ,
            children:
            List.generate(UIItem.clientOption.length, (index) {
              return InkWell(
                  onTap: () {
                    String event = UIItem.clientOption[index]["event"];
                    switch(event) {
                    case OPTION_TOTAL:
                      ConsolePrint("OPTION", "TOTAL");

                      // context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_MainMenu, context: context, userData: widget.userData));
                      break;
                    case OPTION_PAYMENT:
                      ConsolePrint("OPTION", "PAYMENT");
                      context.read<MainBloc>().add(MainParam.GetPayments(eventStatus: MainEvent.Event_Payments, userData: widget.userData));
                      break;
                    case OPTION_VOID:
                      break;
                    case OPTION_REFUND:
                        break;
                    case OPTION_DISCOUNT:
                      ConsolePrint("OPTION", "DISCOUNT");
                      context.read<MainBloc>().add(MainParam.GetDiscounts(eventStatus: MainEvent.Event_GetDiscounts, userData: widget.userData));
                      break;
                    case OPTION_ITEM:
                      context.read<MainBloc>().add(MainParam.GetItems(eventStatus: MainEvent.Event_Items, userData: widget.userData));
                      break;
                    case OPTION_LOOKUP:
                      break;
                    default:
                      break;
                    }

                  },
                  child:  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: Center(
                          child: Text(
                            UIItem.clientOption[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      )
                  )
              );
            }),
          ),
        )
    );
  }

  final ScrollController _scroll = ScrollController();
  Widget optionItemTop() {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scroll,
      child: ListView.builder(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          itemCount: UIItem.clientOptionTop.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                String event = UIItem.clientOptionTop[index]["event"];
                switch(event) {
                  case OPTION_RETURN:
                    context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_MainMenu, context: context, userData: widget.userData));
                    break;
                  case OPTION_SETUP:
                    break;
                  case OPTION_ADVANCE:
                    break;
                  default:
                    break;
                }


              },
              child:  Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(
                      child: Text(
                        UIItem.clientOptionTop[index]["name"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
              )
            );
          }
      ),
    );
  }

  Widget solidButton(String text, String event) {
    return ListTile(
        title: ElevatedButton(

          // style: style,
          style: ElevatedButton.styleFrom(

              minimumSize: const Size(0,50) // put the width and height you want
          ),
          onPressed: solidBtnOnClick(text, event),
          child: Text(text),
        )
    ) ;
  }

  VoidCallback? solidBtnOnClick(String text, String event) {
    return () {
      solidButtonEvent(event);
    };

  }

  void solidButtonEvent(String event) {
    if (event == EVENT_CONFIRM) {
      ConsolePrint("AddITEM", "TEST");

      context.read<MainBloc>().add(MainParam.ItemCheckout(eventStatus: MainEvent.Event_Add_Item_Checkout, userData: widget.userData, productData: null, productOrder: this.productOrder));

    }
  }

}