// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/API/MapValues.dart' as MapValue;
import 'package:npos/Constant/API/MapValues.dart';
import 'package:npos/Constant/UI/Product/ProductShareUIValues.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;
import 'package:npos/Constant/UIEvent/AddUpdateUpcItemCodeEvent.dart';
import 'package:npos/Constant/Values/NumberValues.dart';
import 'package:npos/Constant/Values/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ApiModel/ItemCodePaginationModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:provider/src/provider.dart';

class CheckoutVoidDialog extends StatefulWidget {
  UserModel? userModel;
  CheckoutVoidDialog({Key? key, required this.userModel}) : super(key: key);
  @override
  Component createState() => Component();
}

class Component extends State<CheckoutVoidDialog> {
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool readOnly = true;
  bool isByWeight = true;

  @override
  void initState() {
    super.initState();

    initialLoad();
  }

  void initialLoad() {
  }



  void appBaseEvent(MainState state) {
    // Executing Generic State
    if (state is GenericInitialState) {
      isLoading = false;
    } else if (state is GenericLoadingState) {
      isLoading = true;
    } else if (state is GenericErrorState) {
      isLoading = false;
      context.read<MainBloc>()
          .add(MainParam.showSnackBar(eventStatus: MainEvent.Show_SnackBar, context: context, snackBarContent: state.error.toString()));
    }
  }

  void app2ndGenericEvent(MainState state) {
    if (state is Generic2ndInitialState) {
    } else if (state is Generic2ndLoadingState) {
    } else if (state is Generic2ndLoadedState) {
    } else if (state is Generic2ndErrorState) {
    }
  }

  void appSpecificEvent(MainState state) {

  }




  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async => false,
        child: Material(
          color: Colors.transparent,
          child: BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
            /**
             * BLoc Action Note
             * START
             * */
            appBaseEvent(state);
            app2ndGenericEvent(state);
            appSpecificEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return buildContainer(context);
          }),
        ));
  }

  Widget buildContainer(context) {
    return updatedBody();
  }

  Widget updatedBody() {

    double height = 0.0;
    if (!isByWeight) {
      height = UISize.dHeightQueryCheckoutByQty;
    } else {
      height = UISize.dHeightQueryCheckoutByWeight;
    }

    return Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height *  height,
            bottom: MediaQuery.of(context).size.height * height,
            left: MediaQuery.of(context).size.width * UISize.dWidthQueryCheckout,
            right: MediaQuery.of(context).size.width * UISize.dWidthQueryCheckout
        ),
        child: Container(
            padding: const EdgeInsets.all(GENERIC_CONTAINER_PADDING),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(GENERIC_BORDER_RADIUS)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ),
                MainBodyWidget()
              ],
            )
        ));
  }

  /// There are 2 scenarios
  /// First is UI for product which sold by weight
  /// Second is UI for product which sold by Unit
  Widget MainBodyWidget() {
    if (isByWeight) {
      return ByWeightWidget();
    } else {
      return ByQuantityWidget();
    }
  }

  Widget ByWeightWidget() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 45),
      child: Form(
        key: formKey,
        child: Row(
          children: [
            Expanded(
                child:
                Column(
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      "Follow the instruction to void the following product",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Text(
                          "Charged Product Information:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Product Description",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Price By Weight",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Weight",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Total Charge",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          children: const [
                            Text(
                              "Select available option to void the charged product",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: SizedBox(),
                        ),
                        Expanded(
                          /// Logic: Disable when number of void field left blank
                            flex: 2,
                            child: solidButton("VOID", "VOID_SPECIFIC")
                        )
                      ],
                    )
                  ],
                )

            )
          ],
        ),
      ),
    );
  }

  Widget ByQuantityWidget() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 45),
      child: Form(
        key: formKey,
        child: Row(
          children: [
            Expanded(
                child:
                Column(
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      "Follow the instruction to void the following product",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Text(
                          "Charged Product Information:",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Product Description",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Price Per Unit",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Number of Item Or Number of Weight (If By Weight)",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: readOnly,
                        labelText: "Total Charge",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          children: const [
                            Text(
                              "Enter number of item you would like to void from this product:",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              "*Remark: you can either or select the available option below\nNumber of void must be less than or equal to charged unit",
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: false,
                        labelText: "Number of Void",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        controller: null,
                        read: true,
                        labelText: "Final Charge After Voided Displays Here",
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ),
                    const SizedBox(height: 60),
                    Row(
                      children: [
                        Expanded(
                          /// Logic: Disable when user enter number of void
                            flex: 2,
                            child: solidButton("VOID ALL", "VOID_ALL")
                        ),
                        Expanded(
                          /// Logic:
                            flex: 2,
                            child: solidButton("VOID ONE", "VOID_ONE")
                        ),
                        Expanded(
                          /// Logic: Disable when number of void field left blank
                            flex: 2,
                            child: solidButton("VOID", "VOID_SPECIFIC")
                        )
                      ],
                    )
                  ],
                )

            )
          ],
        ),
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
    if (event.isEmpty) {
      return null;
    } else {
      return () {
        solidButtonEvent(event);
      };
    }
  }

  /// Actual Event Goes In This Method
  void solidButtonEvent(String event) {


  }



  Widget txtButton(text) {
    return TextButton(
      // style: style,
      onPressed: () {},
      child: Text(text),
    );
  }


}

