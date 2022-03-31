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
import 'package:npos/Model/ApiModel/UserPaginationModel.dart';
import 'package:npos/Model/UserRelationModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
class Employee extends StatefulWidget {
  UserModel? userData;
  Employee({Key? key, required this.userData}) : super(key: key);

  @override
  Component createState() => Component();
}

class Component extends State<Employee> {
  String dropdownValue = 'Search By Employee Name';
  bool isChecked = false;
  TextEditingController eTSearchTopBy = TextEditingController();
  TextEditingController eTFirstName = TextEditingController();
  TextEditingController eTLastName = TextEditingController();
  TextEditingController eTPrimaryEmail = TextEditingController();
  TextEditingController eTSecondaryEmail = TextEditingController();
  TextEditingController eTAddress = TextEditingController();
  TextEditingController eTPhoneNumber = TextEditingController();
  TextEditingController eTUserType = TextEditingController();
  TextEditingController eTUserName = TextEditingController();
  TextEditingController eTPassword = TextEditingController();
  TextEditingController eTStoreLocation = TextEditingController();
  TextEditingController eTCreated = TextEditingController();
  TextEditingController eTUpdated = TextEditingController();
  TextEditingController eTUserId = TextEditingController();
  int searchOptionValue = 0;
  Map<int, String> searchOptionByParam = <int, String>{
    0:"Search By Employee Name"
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
   // context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetVendorPaginateCount, userData: widget.userData, productParameter: {"searchType": "test"}));
    context.read<MainBloc>().add(MainParam.GetUserPagination(eventStatus: MainEvent.Event_GetUserPagination, userData: widget.userData, userParameter: {"startIdx": "0", "endIdx": "100" , "userFullName": ""}));
  }

  List<UserRelationModel> listUserPaginate = [];
  int dataCount = 0;
  UserRelationModel? currentModel;
  bool isAdded = false;
  void appSpecificEvent(MainState state) {
    // Executing Specific State
    if (state is UserPaginationLoadingState) {
      isLoadingTable = true;
    } else if (state is UserPaginationLoadedState) {
      isLoadingTable = false;
      UserPaginationModel response = state.response!;
      response.print();
      listUserPaginate = response.userRelationModels;
    } else if (state is UserPaginationLoadedErrorState) {
      isLoadingTable = false;
    }
  }

  void appGetUserByIdEvent(MainState state) {
    if (state is UserByIdInitState) {
    } else  if (state is UserByIdLoadingState) {

    } else if (state is UserByIdLoadedState) {
      UserRelationModel response = state.response!;
      parsingProductDataToUI(response);
    } else if (state is UserByIdLoadedErrorState) {
    }
  }

  void clearEditText() {
     eTSearchTopBy = TextEditingController();
     eTFirstName = TextEditingController();
     eTLastName = TextEditingController();
     eTPrimaryEmail = TextEditingController();
     eTSecondaryEmail = TextEditingController();
     eTAddress = TextEditingController();
     eTPhoneNumber = TextEditingController();
     eTUserType = TextEditingController();
     eTUserName = TextEditingController();
     eTPassword = TextEditingController();
     eTStoreLocation = TextEditingController();
     eTCreated = TextEditingController();
     eTUpdated = TextEditingController();
     eTUserId = TextEditingController();
  }
  void parsingProductDateByDescription (List<UserRelationModel> modelList) {
    dataCount = modelList.length;
    listUserPaginate = modelList;
    isLoadingTable = false;
  }
  void parsingProductDataToUI(UserRelationModel model) {
    eTUserId.text = model.uid;
    eTFirstName.text = model.firstName;
    eTLastName.text = model.lastName;
    eTPrimaryEmail.text = model.email;
    eTSecondaryEmail.text = model.email2 ?? "";
    eTPhoneNumber.text = model.phone ?? "";
    eTAddress.text = model.address ?? "";
    eTUserType.text = model.userType ?? "";
    eTUserName.text = model.userName;
    eTPassword.text = model.password ?? "";
    eTStoreLocation.text = "TO BE Implemented";
    eTCreated.text = model.addedBy! + " On " + model.addedDateTime!;
    eTUpdated.text = model.updatedBy == null ? "Not Available" : model.updatedBy! + " On " + model.updatedDateTime!;
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
      appGetUserByIdEvent(state);
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
            child: solidButton("New User", "NEW-VENDOR")
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
                  controller: eTUserId,
                  labelText: "User Id",
                  hintText: "User Id",
                  isMask: false, isNumber:false,
                  mask: false,

                ),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Custom_ListTile_TextField(
                          read: false,
                          controller: eTFirstName,
                          labelText: "First Name",
                          hintText: "First Name",
                          isMask: false, isNumber:false,
                          mask: false,
                          validations: (value) {
                            if(eTFirstName.text.isNotEmpty) {
                              return null;
                            } else {
                              return "Please Provide First Name";
                            }
                          },
                        )
                    ),
                    Expanded(
                        flex: 5,
                        child: Custom_ListTile_TextField(
                          read: false,
                          controller: eTLastName,
                          labelText: "Last Name",
                          hintText: "Last Name",
                          isMask: false, isNumber:false,
                          mask: false,
                          validations: (value) {
                            if(eTLastName.text.isNotEmpty) {
                              return null;
                            } else {
                              return "Please Provide Last Name";
                            }
                          },
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Custom_ListTile_TextField(
                          read: false,
                          controller: eTPrimaryEmail,
                          labelText: "Primary Email",
                          hintText: "Primary Email",
                          isMask: false,
                          isNumber:false,
                          mask: false,
                        )
                    ),
                    Expanded(
                        flex: 5,
                        child: Custom_ListTile_TextField(
                          read: false,
                          controller: eTSecondaryEmail,
                          labelText: "Secondary Email",
                          hintText: "Secondary Email",
                          isMask: false,
                          isNumber:false,
                          mask: false,
                        )
                    )
                  ],
                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTPhoneNumber,
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  isMask: false,
                  isNumber:false,
                  mask: false,
                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTAddress,
                  labelText: "Primary Address",
                  hintText: "Primary Address",
                  isMask: false,
                  isNumber:false,
                  mask: false,
                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTUserType,
                  labelText: "User Type",
                  hintText: "User Type",
                  isMask: false,
                  isNumber:false,
                  mask: false,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Custom_ListTile_TextField(
                          read: false,
                          controller: eTUserName,
                          labelText: "Username",
                          hintText: "Username",
                          isMask: false,
                          isNumber:false,
                          mask: false,
                        )
                    ),
                    Expanded(
                        flex: 5,
                        child: Custom_ListTile_TextField(
                          read: false,
                          controller: eTPassword,
                          labelText: "Password",
                          hintText: "Password",
                          isMask: false,
                          isNumber:false,
                          mask: false,
                        )
                    )
                  ],
                ),
                Custom_ListTile_TextField(
                  read: false,
                  controller: eTStoreLocation,
                  labelText: "Store Location",  //Default Location Is Always the current location
                  hintText: "Store Location",
                  isMask: false,
                  isNumber:false,
                  mask: false,
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
                      child:  isAdded? solidButton("Add New User", "ADD") : solidButton("Save User", "UPDATE")
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
    DataTableSource _data = TableData(listUserPaginate, dataCount, context, widget.userData);
    return PaginatedDataTable2(
      columns: const [
        DataColumn(label: Text('User Id')),
        DataColumn(label: Text('Full Name')),
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('User Type')),
        DataColumn(label: Text('Added Datetime')),
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
      context.read<MainBloc>().add(MainParam.GetVendorByParam(eventStatus: MainEvent.Event_GetVendorByDescription, userData: widget.userData, vendorParameter: {"description" : eTSearchTopBy.text}));
    } else if (event == "NEW-VENDOR") {
      context.read<MainBloc>().add(MainParam.AddItemMode(eventStatus: MainEvent.Local_Event_NewItem_Mode, isAdded: true));
    } else if (event == "UPDATE") {
      // bool val = formKey.currentState!.validate();
      // ConsolePrint("Validate", val);
      // if (val) {
      //   context.read<MainBloc>().add(MainParam.AddUpdateVendor(eventStatus: MainEvent.Event_UpdateVendor, userData: widget.userData, vendorParameter: {
      //     "desc": eTVendorName.text,
      //     "note": eTVendorNote.text,
      //     "id": eTVendorId.text
      //   }));
      // }

    } else if (event == "ADD") {
      // bool val = formKey.currentState!.validate();
      // ConsolePrint("Validate", val);
      // if (val) {
      //   context.read<MainBloc>().add(MainParam.AddUpdateVendor(eventStatus: MainEvent.Event_AddVendor, userData: widget.userData, vendorParameter: {
      //     "desc": eTVendorName.text,
      //     "note": eTVendorNote.text,
      //   }));
      // }
    }
  }


}

class TableData extends DataTableSource {
  BuildContext context;
  dynamic userData;
  int dataCount = 0;
  List<UserRelationModel> lstModel = [];
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
          UserRelationModel selectedModel = lstModel[index];
          context.read<MainBloc>().add(MainParam.GetUserByIdLocal(eventStatus: MainEvent.Event_GetUserById_Local, userData: userData, userRelationModel: selectedModel));
        },
        cells: [
          DataCell(Text(lstModel[index].uid.toString())),
          DataCell(Text(lstModel[index].firstName.toString() + " " + lstModel[index].lastName.toString())),
          DataCell(Text(lstModel[index].userName.toString())),
          DataCell(Text(lstModel[index].userType.toString())),
          DataCell(Text(lstModel[index].addedDateTime.toString())),
          DataCell(Text(lstModel[index].updatedDateTime.toString()))
        ]
    );
  }
}