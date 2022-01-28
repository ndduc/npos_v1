// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
class Category extends StatefulWidget {
  UserModel? userData;
  Category({Key? key, required this.userData}) : super(key: key);

  @override
  Component createState() => Component();
}

class Component extends State<Category> {
  String dropdownValue = 'Search By Product Id';
  bool isChecked = false;
  TextEditingController eTSearchTopBy = TextEditingController();
  TextEditingController eTCategoryName = TextEditingController();
  TextEditingController eTCategoryNote = TextEditingController();
  TextEditingController eTCreated = TextEditingController();
  TextEditingController eTUpdated = TextEditingController();
  TextEditingController eTCategoryId = TextEditingController();
  int searchOptionValue = 0;
  Map<int, String> searchOptionByParam = <int, String>{
    0:"Search By Category Name"
  };
  int defaultProductMode = 0;
  bool isLoading = false;
  var formKey = GlobalKey<FormState>();

  void appBaseEvent(MainState state) {
    // Executing Generic State
    if (state is GenericInitialState) {
      isLoading = false;
    } else if (state is GenericLoadingState) {
      isLoading = false;
    } else if (state is GenericErrorState) {
      isLoading = false;
    }
  }

  void appNestedEvent(MainState state) {
    if (state is Generic2ndInitialState) {
    } else if (state is Generic2ndLoadingState) {
    } else if (state is Generic2ndLoadedState) {
    } else if (state is Generic2ndErrorState) {
    }
  }

  @override
  void initState() {
    super.initState();
    loadOnInit();
  }

  loadOnInit() {
    context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetCategoryPaginateCount, userData: widget.userData, productParameter: {"searchType": "test"}));
  }

  List<CategoryModel> listCategoryPaginate = [];
  int dataCount = 0;
  CategoryModel? currentModel;
  bool isAdded = false;
  void appSpecificEvent(MainState state) {
    // Executing Specific State
    if (state is CategoryPaginateLoadingState) {
      isLoadingTable = true;
    } else if (state is CategoryPaginateLoadedState) {
      isLoadingTable = false;
      listCategoryPaginate = state.listCategoryModel!;
    } else if (state is CategoryPaginateCountLoadedState) {
      isLoadingTable = false;
      // Invoke Load Paginate Product After Count is Completed
      dataCount = state.count!;
      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetCategoryPaginate, userData: widget.userData, productParameter: {
        "searchType": "test",
        "startIdx": 1,
        "endIdx": 10
      }));
    } else if (state is CategoryLoadedState) {
      currentModel = state.categoryModel;
      parsingProductDataToUI(currentModel!);
      context.read<MainBloc>().add(MainParam.AddItemMode(eventStatus: MainEvent.Local_Event_NewItem_Mode, isAdded: false));
    } else if (state is CategoryByDescriptionLoadedState) {
      parsingProductDateByDescription(state.listCategoryModel!);
    } else if (state is AddItemModeLoaded) {
      ConsolePrint("MODE TEST", state.isAdded!);
      isAdded = state.isAdded!;
      if (isAdded) {
        eTCategoryId.text = "Category Id Will Be Generated Once The Process Is Completed";
        clearEditText();
      }
    } else if (state is AddUpdateCategoryLoaded) {
      ConsolePrint("RESPONSE", state.isSuccess.toString());
      if(state.isSuccess!) {
        loadOnInit();
      } else {
        // Pop A snackbar or a dialog here
      }
    }
  }

  void clearEditText() {
    eTCategoryNote = TextEditingController();
    eTCategoryName = TextEditingController();
    eTCreated = TextEditingController();
    eTUpdated = TextEditingController();
  }
  void parsingProductDateByDescription (List<CategoryModel> modelList) {
    dataCount = modelList.length;
    listCategoryPaginate = modelList;
    isLoadingTable = false;
  }
  void parsingProductDataToUI(CategoryModel model) {
    eTCategoryName.text = model.description!;
    eTCategoryNote.text = model.second_description == null ? "" : model.second_description!;
    eTCreated.text = model.added_by! + " On " + model.added_datetime!;
    eTUpdated.text = model.updated_by == null ? "Not Available" : model.updated_by! + " On " + model.updated_by!;
    eTCategoryId.text = model.uid!;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
      /**
       * BLoc Action Note
       * START
       * */
      appBaseEvent(state);
      appNestedEvent(state);
      appSpecificEvent(state);
      /**
       * Bloc Action Note
       * END
       * */
      return mainItem();
    });
  }

  Widget mainItem() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:  Container(
          width: MediaQuery.of(context).size.width * 0.78,
          height: MediaQuery.of(context).size.height * 0.98,
          child: Row(
            children: [
              // Add Tab View Here
              Expanded(
                  flex: 5,
                  child: prodManLeftPanel()
              ),
              Expanded(
                  flex: 4,
                  child: prodManRightPanel()
              )
            ],
          ),
        )
    );
  }

  Widget prodManLeftPanel() {
    return Column(
        children:[
          Expanded(
              flex: 1,
              child:prodManLeftTopPanel()
          ),
          Expanded(
            flex: 8,
            child:prodManLeftMidPanel(),
          ),
          Expanded(
            flex: 1,
            child: prodManLeftBotPanel(),
          )
        ]
    );
  }

  Widget prodManLeftTopPanel() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: solidButton("New Category", "NEW-CATEGORY")
        ),

        Expanded(
            flex: 2,
            child: solidButton("Search", "SEARCH")
        ),
        Expanded(
            flex: 2,
            child: DropdownButton<int>(
              isExpanded: true,
              value: searchOptionValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(
                  color: Colors.deepPurple
              ),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (int? newValue) {
                context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "SEARCH-BY-MAP"));
              },
              items: searchOptionByParam
                  .map((key, value) {
                return MapEntry(
                    key,
                    DropdownMenuItem<int>(
                      value: key,
                      child: Text(value),
                    ));
              }).values.toList(),
            )
        ),
        Expanded(
            flex: 4,
            child: Custom_ListTile_TextField(
                read: false,
                controller: eTSearchTopBy,
                labelText: "TEST LABEL",
                hintText: "TEST",
                isMask: false, isNumber:false,
                mask: false
            )
        ),
      ],
    );
  }

  /*
  * Consist of middle left product management stuff
  * */
  Widget prodManLeftMidPanel() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
            key: formKey,
            child: Column(
              children: [
                Custom_ListTile_TextField(
                  read: true,
                  controller: eTCategoryId,
                  labelText: "Category Id",
                  hintText: "Category Id",
                  isMask: false, isNumber:false,
                  mask: false,

                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTCategoryName,
                  labelText: "Category Name",
                  hintText: "Category Name",
                  isMask: false, isNumber:false,
                  mask: false,
                  validations: (value) {
                    if(eTCategoryName.text.isNotEmpty) {
                      return null;
                    } else {
                      return "Please Provide Description";
                    }
                  },

                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTCategoryNote,
                  labelText: "User's Note",
                  hintText: "User's Note",
                  isMask: false, isNumber:false,
                  mask: false,
                  maxLines: 5,
                )
              ],
            )
        )
    ) ;
  }

  Widget prodManLeftBotPanel() {
    return Column (
      children: [
        Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  const Expanded(
                      flex: 3,
                      child:  SizedBox()
                  ),
                  const Expanded(
                      flex: 3,
                      child:  SizedBox()
                  ),
                  Expanded(
                      flex: 3,
                      child:  isAdded? solidButton("Add New Category", "ADD") : solidButton("Save Category", "UPDATE")
                  )
                ],
              ),
            )
        ),
        Expanded(
            flex: 6,
            child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    read: true,
                                    controller: eTCreated,
                                    labelText: "Created By/Datetime",
                                    hintText: "TEST",
                                    isMask: false, isNumber:false,
                                    mask: false
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    read: true,
                                    controller: eTUpdated,
                                    labelText: "Last Updated By/Datetime",
                                    hintText: "TEST",
                                    isMask: false, isNumber:false,
                                    mask: false
                                )
                            )
                          ],
                        ))
                  ],
                )
            )
        )
      ],
    );
  }

  bool isLoadingTable = false;
  Widget prodManRightPanel() {
    return isLoadingTable ?  ShareSpinner() : paginateTable();
  }

  Widget paginateTable() {
    DataTableSource _data = TableData(listCategoryPaginate, dataCount, context, widget.userData);
    return PaginatedDataTable2(
      columns: const [
        DataColumn(label: Text('Product Id')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Created Datetime')),
        DataColumn(label: Text('Updated Datetime')),
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

  Widget solidButton(String text, String event) {
    return ListTile(
        title: ElevatedButton(
          // style: style,
          style: ElevatedButton.styleFrom(

              minimumSize: const Size(0,50) // put the width and height you want
          ),
          onPressed: solidBtnOnClick(text, event),
          child:
          Text(
              text,
              textAlign: TextAlign.center
          ),
        )
    ) ;
  }

  VoidCallback? solidBtnOnClick(String text, String event) {
    if(defaultProductMode == 0) {
      switch (text) {
        default:
          return () {
            solidButtonEvent(event);
          };
      }
    }
  }

  void solidButtonEvent(String event) {
    if (event == "SEARCH") {
      context.read<MainBloc>().add(MainParam.GetCategoryByParam(eventStatus: MainEvent.Event_GetCategoryByDescription, userData: widget.userData, categoryParameter: {"description" : eTSearchTopBy.text}));
    } else if (event == "NEW-CATEGORY") {
      context.read<MainBloc>().add(MainParam.AddItemMode(eventStatus: MainEvent.Local_Event_NewItem_Mode, isAdded: true));
    } else if (event == "UPDATE") {
      bool val = formKey.currentState!.validate();
      ConsolePrint("Validate", val);
      if (val) {
        context.read<MainBloc>().add(MainParam.AddUpdateCategory(eventStatus: MainEvent.Event_UpdateCategory, userData: widget.userData, categoryParameter: {
          "desc": eTCategoryName.text,
          "note": eTCategoryNote.text,
          "id": eTCategoryId.text
        }));
      }

    } else if (event == "ADD") {
      bool val = formKey.currentState!.validate();
      ConsolePrint("Validate", val);
      if (val) {
        context.read<MainBloc>().add(MainParam.AddUpdateCategory(eventStatus: MainEvent.Event_AddCategory, userData: widget.userData, categoryParameter: {
          "desc": eTCategoryName.text,
          "note": eTCategoryNote.text,
        }));
      }
    }
  }


}

class TableData extends DataTableSource {
  BuildContext context;
  dynamic userData;
  int dataCount = 0;
  List<CategoryModel> lstModel = [];
  TableData(this.lstModel, this.dataCount, this.context, this.userData);

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
          CategoryModel selectedModel = lstModel[index];
          Map<String, String> map = <String, String>{};
          map["categoryId"] = selectedModel.uid!;
          context.read<MainBloc>().add(MainParam.GetCategoryByParam(eventStatus: MainEvent.Event_GetCategoryById, userData: userData, categoryParameter: map));
        },
        cells: [
          DataCell(Text(lstModel[index].uid.toString())),
          DataCell(Text(lstModel[index].description.toString())),
          DataCell(Text(lstModel[index].added_datetime.toString())),
          DataCell(Text(lstModel[index].updated_datetime.toString()))
        ]
    );
  }
}