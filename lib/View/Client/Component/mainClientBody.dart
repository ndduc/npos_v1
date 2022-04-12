// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/Product/ProductShareUIValues.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UIEvent/addProductEvent.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/POSClientModel/ProductCheckOutModel.dart';
import 'package:npos/Model/POSClientModel/ProductOrderModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/Home/homeMenu.dart';

import '../../Component/Stateful/customDialog.dart';

class MainClientBody extends StatefulWidget {
  UserModel? userData;
  MainClientBody({Key? key, this.userData}) : super(key: key);

  @override
  _MainClientBody createState() => _MainClientBody();
}

class _MainClientBody extends State<MainClientBody> {

  ProductOrderModel productOrder = ProductOrderModel();

  @override
  void initState() {
    super.initState();
  }

  void initProductOrderTesting() {
    productOrder.orderUId = 1;
    productOrder.orderId = 1;
    productOrder.orderAddDateTime = DateTime.now();
    productOrder.orderUpdateDateTime = DateTime.now();
    productOrder.transaction = {};

    ProductCheckOutModel tempProd1 = ProductCheckOutModel();
    tempProd1.uid = "PRODUCT_123";
    tempProd1.description = "TEST PRODUCT";
    tempProd1.cost = 1.00;
    tempProd1.price = 5.00;
    productOrder.transaction["1"] = tempProd1;
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
    return Row(
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
    );
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
            )
        )
      ],
    );
  }

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
              return Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
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
                  case "RT":
                    context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_MainMenu, context: context, userData: widget.userData));
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
    }
  }

}