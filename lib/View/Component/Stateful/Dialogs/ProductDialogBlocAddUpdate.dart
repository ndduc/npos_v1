// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:provider/src/provider.dart';

class ProductDialogBlocAddUpdate extends StatefulWidget {
  String? whoAmI;
  ProductModel? productModel;
  ProductDialogBlocAddUpdate({Key? key, required this.whoAmI, required this.productModel}) : super(key: key);
  @override
  Component createState() => Component();
}

class Component extends State<ProductDialogBlocAddUpdate> {
  bool addNewItemCode = false;
  uiImage uImage = uiImage();
  bool isLoading = false;
  bool readOnly = true;

  @override
  void initState() {
    super.initState();
    ConsolePrint("TEST", widget.whoAmI);
    uiFunctionHandler();
  }

  void uiFunctionHandler() {
    if (addNewItemCode) {

    } else {
      setValue();
    }
  }

  void setValue() {

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

    return Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * UISize.dHeightQuery,
            bottom: MediaQuery.of(context).size.height * UISize.dHeightQuery,
            left: MediaQuery.of(context).size.width * UISize.dWidthQuerySm ,
            right: MediaQuery.of(context).size.width * UISize.dWidthQuerySm ,
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.blueAccent),
          ),
          child: Column(
            children: [
              Text("Would You Like To Modify This Product?"),
              Text("Please Review Carefully Before Proceed?"),
              solidButton("Yes", "YES"),
              solidButton("No", "NO")
            ],
          ),

        ));
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
    if(event == "RETURN") {
      print("RETURN");
      Navigator.pop(context);
    } else if (event == "YES") {
      Navigator.pop(context, true);
    } else if (event == "NO") {
      Navigator.pop(context, false);
    }
  }



  Widget txtButton(text) {
    return TextButton(
      // style: style,
      onPressed: () {},
      child: Text(text),
    );
  }


}
