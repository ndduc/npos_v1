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

class CustomDialogBloc extends StatefulWidget {
  UserModel? userModel;
  ProductModel? productMode;
  String? whoAmI;
  CustomDialogBloc({Key? key, required this.userModel, required this.productMode, required this.whoAmI}) : super(key: key);
  @override
  Component createState() => Component();
}

class Component extends State<CustomDialogBloc> {
  uiImage uImage = uiImage();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
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
            left: MediaQuery.of(context).size.width * UISize.dWidthQuery,
            right: MediaQuery.of(context).size.width * UISize.dWidthQuery),
        child: Container(
          padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child:
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Custom_ListTile_TextField(
                                    read: false,
                                    labelText: "Item Code",
                                    hintText: "TEST",
                                    isMask: false,
                                    mask: false
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: solidButton("New Item Code", "NEW-ITEM-CODE-MODE")
                              )
                            ],
                          ),

                          Custom_ListTile_TextField(
                              read: false,
                              labelText: "Item Description",
                              hintText: "TEST",
                              isMask: false,
                              mask: false
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    read: true,
                                    labelText: "Price",
                                    hintText: "TEST",
                                    isMask: false,
                                    mask: false
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    read: true,
                                    labelText: "Cost",
                                    hintText: "TEST",
                                    isMask: false,
                                    mask: false
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    read: true,
                                    labelText: "Margin",
                                    hintText: "TEST",
                                    isMask: false,
                                    mask: false
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    read: true,
                                    labelText: "Markup",
                                    hintText: "TEST",
                                    isMask: false,
                                    mask: false
                                ),
                              )
                            ],
                          ),
                          Custom_ListTile_TextField(
                            read: true,
                            labelText: "Extended Description",
                            hintText: "TEST",
                            isMask: false,
                            mask: false,
                            maxLines: 5,
                          ),
                          Custom_ListTile_TextField(
                            read: true,
                            labelText: "User's Note",
                            hintText: "TEST",
                            isMask: false,
                            mask: false,
                            maxLines: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: SizedBox()
                              ),
                              Expanded(
                                  flex: 3,
                                  child: solidButton("Close", "RETURN")
                              ),
                              Expanded(
                                  flex: 3,
                                  child: solidButton("Save", "SAVE-ITEM-CODE")
                              )
                            ],
                          )
                        ],
                      )

                ),
                Expanded(
                    flex: 5,
                    child:    paginateTable()
                )
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
    }
  }



  Widget txtButton(text) {
    return TextButton(
      // style: style,
      onPressed: () {},
      child: Text(text),
    );
  }

  Widget paginateTable() {
    DataTableSource _data = TableData([], 0, context);
    return PaginatedDataTable2(
      columns: const [
        DataColumn(label: Text('Product Id')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Created Datetime')),
      ],
      source: _data,
      // horizontalMargin: 50,
      // checkboxHorizontalMargin: 12,
      columnSpacing: 25,
      wrapInCard: false,
      rowsPerPage: 15,
      autoRowsToHeight: true, // match width and height
      minWidth: 800, // enable horizontal scroll -- this also set width of the column
      fit: FlexFit.tight,
      initialFirstRowIndex: 0,

    );
  }
}

class TableData extends DataTableSource {
  BuildContext context;
  dynamic userData;
  int dataCount = 0;
  List<ItemCodeModel> lstModel = [];
  TableData(this.lstModel, this.dataCount, this.context);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => lstModel.length ;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow2(
        onLongPress: () {
          ItemCodeModel selectedModel = lstModel[index];
          Map<String, String> map = <String, String>{};
          map["id"] = selectedModel.id!;
          // context.read<MainBloc>().add(
          //     MainParam.GetProductByParam(
          //         eventStatus: MainEvent.Event_GetProductByParamMap,
          //         userData: userData,
          //         productParameter: map));
        },
        cells: [
          DataCell(Text(lstModel[index].id.toString())),
          DataCell(Text(lstModel[index].itemCode.toString())),
          DataCell(Text(lstModel[index].ItemDescription.toString()))
        ]
    );
  }
}
