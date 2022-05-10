// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/Dummy/DummyValues.dart';
import 'package:npos/Constant/Enum/CheckoutEnum.dart';
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

  TextEditingController scannerController = TextEditingController();
  /// dummy list
  List<Map<dynamic, dynamic>> categories = [];
  List<Map<dynamic, dynamic>> subCategories = [];
  List<Map<dynamic, dynamic>> products = [];

  /// logic here is to switch between sub cat and product
  bool isProduct = false;
  bool isKeyboard = false;

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
            appLookupEvent(state);
            appKeyboardEvent(state);
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

        isKeyboard ? displayKeyboard() : const SizedBox()


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
    isProduct = false;
    if (state is CheckoutItemsInit) {

    } else if (state is CheckoutItemsLoading) {

    } else if (state is CheckoutItemsLoaded) {
      loadEvent = OPTION_ITEM;
      if (state.option == CheckoutEnum.CATEGORY) {
        generateAssociateCategory(state.categoryAssociationModel, state.subCategoryAssociationModel);
      } else if (state.option == CheckoutEnum.SUBCATEGORY) {
        generateAssociateSubCategory(state.subCategoryAssociationModel);

      } else if (state.option == CheckoutEnum.PRODUCT) {
        isProduct = true;
        generateAssociateProduct(state.productAssociationModel);
      }
    } else if (state is CheckoutItemsError) {

    }
  }

  void appLookupEvent(MainState state) {
    if (state is CheckoutLookupInit) {

    } else if (state is CheckoutLookupLoading) {

    } else if (state is CheckoutLookupLoaded) {
      loadEvent = OPTION_LOOKUP;
    } else if (state is CheckoutLookupError) {

    }
  }

  void appKeyboardEvent(MainState state) {
    if (state is CheckoutKeyboardInit) {

    } else if (state is CheckoutKeyboardLoading) {

    } else if (state is CheckoutKeyboardLoaded) {
      isKeyboard = state.isKeyboard;
    } else if (state is CheckoutKeyboardError) {

    }
  }

  void generateAssociateCategory(List<Map<dynamic, dynamic>> model, List<Map<dynamic, dynamic>> firstSubModel) {
    model.isEmpty ? categories = [] : categories = model;
    firstSubModel.isEmpty ? subCategories = []: subCategories = firstSubModel;
  }

  void generateAssociateSubCategory(List<Map<dynamic, dynamic>> model) {
    model.isEmpty ? subCategories = [] : subCategories = model;
  }

  void generateAssociateProduct(List<Map<dynamic, dynamic>> model) {
    model.isEmpty ? products = [] : products = model;
  }

  Widget bodyCheckOut() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: Colors.blueAccent),
          ),
          /// Depend on business, this input will be updated accordingly
          /// example: grocery then it will be UPC
          ///          service model then it will be some kind of user defined code
          child: TextFormField(
            onTap: () {
              /// fire keyboard on tap
              context.read<MainBloc>().add(MainParam.KeyboardOpenClose(eventStatus: MainEvent.Event_Keyboard_OpenClose, isKeyboard: !isKeyboard));
            },
            controller: scannerController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Scan or Enter Item Upc",
              hintText: "Hint",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),

        ),
        // Row(
        //   children: [
        //     Expanded(
        //         // flex: 8,
        //         child: // Text("TEST 4-1"),
        //
        //
        //     ),
        //     // Expanded(
        //     //     flex: 2,
        //     //     child: // Text("TEST 4-1"),
        //     //     solidButton(BTN_CONFIRM, EVENT_CONFIRM)
        //     //
        //     // ),
        //   ],
        // ),

        Expanded(
          flex: 7,
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
                              flex: 1,
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
                                        ConsolePrint("PRODUCT", "VOID");
                                        context.read<MainBloc>().add(MainParam.NavDialogPOSClient(eventStatus: MainEvent.Nav_Event_POS_VOID_Dialog
                                            , context: context, userData: widget.userData));
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
                                        context.read<MainBloc>().add(MainParam.NavDialogPOSClient(eventStatus: MainEvent.Nav_Event_POS_OVERRIDE_Dialog
                                            , context: context, userData: widget.userData));
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
          child: Container(
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child:
            Row(
              children: [
                Expanded(
                    flex: 5,
                    child:  Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Number of Item: ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "5",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Number of Void: ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "2",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Amount of Refund: ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "5",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Sub Total: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "\$51.00",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                            )
                          ],
                        )

                      ],
                    )
                ),
                Expanded(
                    flex: 5,
                    child:  Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Total Discount (\$): ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "\$5.00",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Total Void (\$): ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "\$5.99",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Total Refunded (\$): ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "\$15.99",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "Total Tax (\$): ",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Text(
                                    "\$5.87",
                                    style: TextStyle(
                                        fontSize: 20
                                    )
                                )
                            )
                          ],
                        )
                      ],
                    )
                )
              ],
            )
          ),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: const [

              Text(
                  "Total (\$): ",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(width: 30),
              Text(
                  "\$100.00",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: Colors.blueAccent),
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
            padding: EdgeInsets.only(top: 10, bottom: 10),
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
                        children: const [
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
      case OPTION_LOOKUP:
        return lookUpContainer();
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

  final ScrollController controller = ScrollController();

  Widget itemGrid() {
    return Column(
      children: [
        Expanded(
              flex: 1,
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: dummyDepartment.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: InkWell(
                    child: Container(
                      child: Text(dummyDepartment[index]["name"]),
                    ),
                    onTap: () {
                      /// The logic will populate Category associate with this Department
                      Map<String, String> param = {
                        "id" : dummyDepartment[index]["id"].toString()
                      };
                      context.read<MainBloc>().add(MainParam.ItemGenericSelection(eventStatus: MainEvent.Event_Department_POS, userData: widget.userData, optionalParameter: param));

                    },
                  ),
                ),
            ),

        ),
        Expanded(
            flex: 9,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) => Card(
                        child: InkWell(
                          child: Container(
                            height: 100,
                            child: Text(categories[index]["name"]),
                          ),
                          onTap: () {
                            /// The logic will populate Sub Category associate with this Category
                            Map<String, String> param = {
                              "id" : categories[index]["id"].toString()
                            };
                            context.read<MainBloc>().add(MainParam.ItemGenericSelection(eventStatus: MainEvent.Event_Category_POS, userData: widget.userData, optionalParameter: param));
                          },
                        ),
                      ),
                    )
                ),
                Expanded(

                    flex: 8,
                    child: generateProductOrSubCat()
                )
              ],
            )
        )
      ],
    );
  }

  Widget generateProductOrSubCat() {
    if (isProduct) {
      ConsolePrint("HIT", "THIS");
      return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Card(
                color: Colors.amber,
                child: Center(child: Text(products[index]["name"])),
              )
            );
          }
      );
    } else {
      return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: subCategories.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              // color: Colors.amber,
              child: Container(
                child: Text(subCategories[index]["name"]),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    color: Colors.white),
              ),
              onTap: () {
                Map<String, String> param = {
                  "dept_id" : "1",
                  "cat_id" : "1",
                  "sub_id" : "1"
                };
                context.read<MainBloc>().add(MainParam.ItemGenericSelection(eventStatus: MainEvent.Event_SubCategory_POS, userData: widget.userData, optionalParameter: param));
              },
            );
          }
      );
    }

  }

  Widget lookUpContainer() {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(
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
        ),
        Expanded(
            flex: 9,
            child: Text("Table Grid Goes, Where we search item by name")
        )
      ],
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
  bool isNumericMode = false;

  /// We are going to cum back to this later
  /// Incorporate this widget with an event, where the keyboard will display upon a click event
  Widget displayKeyboard() {
    /// Align would allow this to display at specific area in stack
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
            ),
            Row(
              children: [
                Expanded(
                    flex: 9,
                    child:  SwitchListTile(
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
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.blueAccent,
                        onPressed: () {
                          /// Logic is to close virtual keyboard
                          context.read<MainBloc>().add(MainParam.KeyboardOpenClose(eventStatus: MainEvent.Event_Keyboard_OpenClose, isKeyboard: !isKeyboard));

                        },
                      ),
                    )
                )
              ],
            ),
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
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(color: Colors.red),
        )
      )

    );
  }
  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text);
      scannerController.text = text;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          scannerController.text = text;
          break;
        case VirtualKeyboardKeyAction.Return:
          /// RETURN === ENTER
          /// this will fire a search event
          // text = text + '\n';
          // scannerController.text = text;
          context.read<MainBloc>().add(MainParam.KeyboardOpenClose(eventStatus: MainEvent.Event_Keyboard_OpenClose, isKeyboard: !isKeyboard));

          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text;
          scannerController.text = text;
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
                      /**
                       * Logic
                       * Redundant -- this can be done on item List View
                       * */
                      break;
                    case OPTION_REFUND:
                      /**
                       * Logic
                       * Display a pop up dialog
                       * allow user to either scan or enter an item would to refund
                       * */
                      context.read<MainBloc>().add(MainParam.NavDialogPOSClient(eventStatus: MainEvent.Nav_Event_POS_REFUND_Dialog
                          , context: context, userData: widget.userData));
                        break;
                    case OPTION_DISCOUNT:
                      /**
                       * Logic
                       * Show all associated discount with logged location
                       * Discount on this option must be order-wise discount where a discount will be applied to the entire order
                      * */
                      ConsolePrint("OPTION", "DISCOUNT");
                      context.read<MainBloc>().add(MainParam.GetDiscounts(eventStatus: MainEvent.Event_GetDiscounts, userData: widget.userData));
                      break;
                      case OPTION_ITEM:
                      /// Logic
                      /// Once clicked, display item widget
                      /// Backend change: dept, cat, sub, and item should now have UI view variable where true mean allow to display on POS client
                      /// initial value should be
                      ///     1st department
                      ///     associated category with the 1st department
                      ///     caching associated sub category with the category above
                      ///     display item associate with all attribute above + item must have UI view set to true
                      context.read<MainBloc>().add(MainParam.GetItems(eventStatus: MainEvent.Event_Items, userData: widget.userData));
                      break;
                    case OPTION_LOOKUP:
                      context.read<MainBloc>().add(MainParam.GetLookup(eventStatus: MainEvent.Event_Lookup, userData: widget.userData));
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
                  case "KEY_BOARD":
                    ConsolePrint("KEYBOARD", "CLICKED");
                    context.read<MainBloc>().add(MainParam.KeyboardOpenClose(eventStatus: MainEvent.Event_Keyboard_OpenClose, isKeyboard: !isKeyboard));

                    break;
                  default:
                    break;
                }
              },
              child:  Container(
                width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  // height: MediaQuery.of(context).size.height * 0.25,
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