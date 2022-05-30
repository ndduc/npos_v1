// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/Product/ProductShareUIValues.dart';
import 'package:npos/Constant/UIEvent/addProductEvent.dart';
import 'package:npos/Constant/Values/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/SubCategoryModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
class SubCategory extends StatefulWidget {
  UserModel? userData;
SubCategory({Key? key, required this.userData}) : super(key: key);

  @override
  Component createState() => Component();
}

class Component extends State<SubCategory> {
  String dropdownValue = 'Search By Product Id';
  bool isChecked = false;
  TextEditingController eTSearchTopBy = TextEditingController();
  TextEditingController eTSubCategoryName = TextEditingController();
  TextEditingController eTSubCategoryNote = TextEditingController();
  TextEditingController eTCreated = TextEditingController();
  TextEditingController eTUpdated = TextEditingController();
  TextEditingController eTSubCategoryId = TextEditingController();
  int searchOptionValue = 0;
  Map<int, String> searchOptionByParam = <int, String>{
    0:"Search By Sub Category Name"
  };
  int defaultProductMode = 0;
  bool isLoading = false;
  var formKey = GlobalKey<FormState>();
  List<SubCategoryModel> listSubCategoryPaginate = [];
  int dataCount = 0;
  SubCategoryModel? currentModel;
  bool isAdded = true;
  bool isLoadingTable = false;

  String? categoryDefault = STRING_NULL;
  Map<String, String> categoryList = {};

  @override
  void initState() {
    super.initState();
    loadOnInitLocal();
    initDependency();
  }

  loadOnInitLocal() {
    categoryList = <String, String>{
      STRING_NULL: DEPARTMENT + WHITE_SPACE + STRING_NOT_FOUND
    };
  }

  /// this one will load existing categories to the view
  loadOnInit() {
    // String deptVal = isAdded ? "" : STRING_NOT_FOUND;

    context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetSubCategoryPaginateCount, userData: widget.userData, productParameter: {"searchType": "test"}));
  }

  /// loading all category's dependency,
  /// likely will trigger after loadOnInit
  initDependency() {
    context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetSubCategoryDependency, userData: widget.userData, productParameter: { "searchText": "" }));
  }



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

  void appSpecificEvent(MainState state) {
    if (state is AddItemModeLoaded) {
      isAdded = state.isAdded!;
      if (isAdded) {
        eTSubCategoryId.text = "Sub Category Id Will Be Generated Once The Process Is Completed";
        clearEditText();
      }
    }
  }

  void appSubCategoryAddUpdate(MainState state) {
    if (state is AddUpdateSubCategoryInitState) {}
    else if (state is AddUpdateSubCategoryLoadingState) {}
    else if (state is AddUpdateSubCategoryLoaded) {
      if(state.isSuccess!) {
        loadOnInit();
      } else {
        // Pop A snackbar or a dialog here
      }
    }
    else if (state is AddUpdateSubCategoryErrorState) {
      ConsolePrint("ERRROR", state.error);
    }
  }

  void appSubCategoryByDescription(MainState state) {
    if (state is SubCategoryByDescriptionInitState) {}
    else if (state is SubCategoryByDescriptionLoadingState) {}
    else if (state is SubCategoryByDescriptionLoadedState) {
      parsingProductDateByDescription(state.listSubCategoryModel!);
    }
    else if (state is SubCategoryByDescriptionErrorState) {}
  }

  void appSubCategory(MainState state) {
    if (state is SubCategoryInitState) {}
    else if (state is SubCategoryLoadingState) {}
    else if (state is SubCategoryLoadedState) {
      currentModel = state.subCategoryModel;
      parsingProductDataToUI(currentModel!);
      context.read<MainBloc>().add(MainParam.AddItemMode(eventStatus: MainEvent.Local_Event_NewItem_Mode, isAdded: false));
    }
    else if (state is SubCategoryErrorState) {
      ConsolePrint("ERROR", state.error);
    }
  }

  void appSubCategoryPaginateCount(MainState state) {
    if (state is SubCategoryPaginateCountInitState) {}
    else if (state is SubCategoryPaginateCountLoadingState) {}
    else if (state is SubCategoryPaginateCountLoadedState) {
      isLoadingTable = false;
      /// Invoke Load Paginate Product After Count is Completed
      dataCount = state.count!;
      if (dataCount > 0) {
        context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetSubCategoryPaginate, userData: widget.userData, productParameter: {
          "searchType": "test",
          "startIdx": 1,
          "endIdx": 10
        }));
      }
    }
    else if (state is SubCategoryPaginateCountErrorState) {}
  }

  void appSubCategoryPaginate(MainState state) {
    if (state is SubCategoryPaginateInitState) {}
    else if (state is SubCategoryPaginateLoadingState) {
      isLoadingTable = true;
    } else if (state is SubCategoryPaginateLoadedState) {
      isLoadingTable = false;
      listSubCategoryPaginate = state.listSubCategoryModel!;
    }
    else if (state is SubCategoryPaginateErrorState) {}
  }

  void appSubCategoryDependencyEvent(MainState state) {
    if (state is SubCategoryDependencyInitState) {
      ConsolePrint("TEST", "INIT");

    } else if (state is SubCategoryDependencyLoadingState) {
      ConsolePrint("TEST", "LOADING");

    } else if (state is SubCategoryDependencyLoadedState) {
      ConsolePrint("TEST", "TEST");
      List<CategoryModel> catList = state.catList;
      setCategoryDropDownValue(catList);
      loadOnInit();
    } else if (state is CategoryDependencyErrorState) {
      ConsolePrint("TEST", "ERROR");

    }

  }

  /// Trigger upon dropdown selection
  void appDropDownEvent(MainState state) {
    if (state is DropDownInitState) {

    } else if (state is DropDownLoadingState) {

    } else if (state is DropDownLoadedState) {
      /// Update value of dept dropdown
      if (state.dropDownType == EVENT_DROPDOWN_DEPARTMENT) {
        categoryDefault = state.dropDownValue;
      }
    } else if (state is DropDownErrorState) {

    }
  }

  void setCategoryDropDownValue(List<CategoryModel> cateList) {
    categoryList = {};
    for(int i = 0; i < cateList.length; i++) {
      if (i == 0) {
        categoryDefault = "-1";
        String catVal = isAdded ? "Select Category Department" :  STRING_NOT_HAVE + WHITE_SPACE + DEPARTMENT;
        categoryList[STRING_NULL] = catVal;
      }
      ConsolePrint("TEST", cateList[i].description!);
      categoryList[cateList[i].uid!] = cateList[i].description!;
    }

  }

  void clearEditText() {
    eTSubCategoryNote = TextEditingController();
    eTSubCategoryName = TextEditingController();
    eTCreated = TextEditingController();
    eTUpdated = TextEditingController();
  }
  void parsingProductDateByDescription (List<SubCategoryModel> modelList) {
    dataCount = modelList.length;
    listSubCategoryPaginate = modelList;
    isLoadingTable = false;
  }
  void parsingProductDataToUI(SubCategoryModel model) {
    eTSubCategoryName.text = model.description!;
    eTSubCategoryNote.text = model.second_description == null ? "" : model.second_description!;
    eTCreated.text = model.added_by! + " On " + model.added_datetime!;
    eTUpdated.text = model.updated_by == null ? "Not Available" : model.updated_by! + " On " + model.updated_by!;
    eTSubCategoryId.text = model.uid!;
    categoryDefault = model.categoryUid;
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
      appSubCategoryPaginateCount(state);
      appSubCategoryPaginate(state);
      appSubCategoryDependencyEvent(state);
      appDropDownEvent(state);
      appSubCategory(state);
      appSubCategoryByDescription(state);
      appSubCategoryAddUpdate(state);
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
                categoryDropDown(),
                Custom_ListTile_TextField(
                  read: true,
                  controller: eTSubCategoryId,
                  labelText: "Sub Category Id",
                  hintText: "Sub Category Id",
                  isMask: false, isNumber:false,
                  mask: false,

                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTSubCategoryName,
                  labelText: "Sub Category Name",
                  hintText: "Sub Category Name",
                  isMask: false, isNumber:false,
                  mask: false,
                  validations: (value) {
                    if(eTSubCategoryName.text.isNotEmpty) {
                      return null;
                    } else {
                      return "Please Provide Description";
                    }
                  },

                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTSubCategoryNote,
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
                      child:  isAdded? solidButton("Add New Sub Category", "ADD") : solidButton("Save Sub Category", "UPDATE")
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


  Widget prodManRightPanel() {
    return isLoadingTable ?  ShareSpinner() : paginateTable();
  }

  Widget paginateTable() {
    DataTableSource _data = TableData(listSubCategoryPaginate, dataCount, context, widget.userData);
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
      context.read<MainBloc>().add(MainParam.GetSubCategoryByParam(eventStatus: MainEvent.Event_GetSubCategoryByDescription, userData: widget.userData, subCategoryParameter: {"description" : eTSearchTopBy.text}));
    } else if (event == "NEW-CATEGORY") {
      context.read<MainBloc>().add(MainParam.AddItemMode(eventStatus: MainEvent.Local_Event_NewItem_Mode, isAdded: true));
    } else if (event == "UPDATE") {
      bool val = formKey.currentState!.validate();
      ConsolePrint("Validate", val);
      if (val) {
        context.read<MainBloc>().add(MainParam.AddUpdateSubCategory(eventStatus: MainEvent.Event_UpdateSubCategory, userData: widget.userData, subCategoryParameter: {
          "desc": eTSubCategoryName.text,
          "note": eTSubCategoryNote.text,
          "id": eTSubCategoryId.text,
          "cat_uid": categoryDefault,
        }));
      }

    } else if (event == "ADD") {
      bool val = formKey.currentState!.validate();
      if (val) {
        ConsolePrint("ADD", "SUB");
        context.read<MainBloc>().add(MainParam.AddUpdateSubCategory(eventStatus: MainEvent.Event_AddSubCategory, userData: widget.userData, subCategoryParameter: {
          "desc": eTSubCategoryName.text,
          "note": eTSubCategoryNote.text,
          "cat_uid": categoryDefault,
        }));
      }
    }
  }



  /// EACH SUB CAT MUSH HAVE AN ASSOCIATED CAT
  Widget categoryDropDown() {
    return  ListTile(
        leading: const Text(TXT_CATEGORY),
        title:  DropdownButton<String>(
          isExpanded: true,
          value: categoryDefault,
          style: const TextStyle(
              color: Colors.deepPurple
          ),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            ConsolePrint("DROP EVENT", newValue);
            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_DEPARTMENT));
          },
          items: categoryList
              .map((key, value) {
            return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(value),
                ));
          }).values.toList(),
        )
    );
  }


}

class TableData extends DataTableSource {
  BuildContext context;
  dynamic userData;
  int dataCount = 0;
  List<SubCategoryModel> lstModel = [];
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
          ConsolePrint("LONG", "PRESS");
          SubCategoryModel selectedModel = lstModel[index];
          Map<String, String> map = <String, String>{};
          map["subCategoryId"] = selectedModel.uid!;

          ConsolePrint("MAP PARAM", map);
          context.read<MainBloc>().add(MainParam.GetSubCategoryByParam(eventStatus: MainEvent.Event_GetSubCategoryById, userData: userData, subCategoryParameter: map));
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