// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UiEvent/menuEvent.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/Home/homeMenu.dart';
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
  int searchOptionValue = 1;
  Map<int, String> searchOptionByParam = <int, String>{
    0:"Search By Category Id",
    1:"Search By Category Code"
  };
  int defaultProductMode = 0;
  bool isLoading = false;

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

  void appSpecificEvent(MainState state) {
    // Executing Specific State

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
                isMask: false,
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
        child: Column(
          children: [
            Custom_ListTile_TextField(
                read: false,
                controller: null,
                labelText: "Category Name",
                hintText: "Category Name",
                isMask: false,
                mask: false
            ),
            Custom_ListTile_TextField(
                read: false,
                controller: null,
                labelText: "Category Code",
                hintText: "Code Must Be Unique For Each Category",
                isMask: false,
                mask: false
            ),
            Custom_ListTile_TextField(
              read: false,
              controller: null,
              labelText: "User's Note",
              hintText: "User's Note",
              isMask: false,
              mask: false,
              maxLines: 5,
            ),
            ListTile(
                leading: Text("Default Discount"),
                title:  DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  style: const TextStyle(
                      color: Colors.deepPurple
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Search By Product Id', 'Search By Item Code', 'Search By Description']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            ),
            ListTile(
                leading: Text("Default Tax Rate"),
                title:  DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  style: const TextStyle(
                      color: Colors.deepPurple
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Search By Product Id', 'Search By Item Code', 'Search By Description']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            )
          ],
        )
    ) ;
  }

  Widget prodManLeftBotPanel() {
    return Column (
      children: [
        Expanded(
          flex: 5,
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
                  child:  solidButton("Update", "UPDATE")
              )
            ],
          ),
        ),
        Expanded(
            flex: 5,
            child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Expanded(
                        flex: 3,
                        child: SizedBox()
                    ),
                    Expanded(
                        flex: 3,
                        child: Custom_ListTile_TextField(
                            read: false,
                            controller: null,
                            labelText: "Created By/Datetime",
                            hintText: "TEST",
                            isMask: false,
                            mask: false
                        )
                    ),
                    Expanded(
                        flex: 3,
                        child: Custom_ListTile_TextField(
                            read: false,
                            controller: null,
                            labelText: "Last Updated By/Datetime",
                            hintText: "TEST",
                            isMask: false,
                            mask: false
                        )
                    )
                  ],
                )
            )
        )
      ],
    );
  }

  Widget prodManRightPanel() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Age',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        ),
      ],
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
        case "Modify ItemCode":
          return null;
        case "Modify Upc":
          return null;
        case "Save To Batch":
          return null;
        case "Update Batch":
          return null;
        case "Update Item":
          return null;
        default:
          return () {
            solidButtonEvent(event);
          };
      }
    } else if (defaultProductMode == 1) {
      return () {
        solidButtonEvent(event);
      };
    } else if (defaultProductMode == 2) {
      return () {
        solidButtonEvent(event);
      };
    } else {
      return () {
        solidButtonEvent(event);
      };
    }
  }

  void solidButtonEvent(String event) {
  }


}