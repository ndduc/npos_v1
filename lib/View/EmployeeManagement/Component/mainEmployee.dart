// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UiEvent/menuEvent.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/Home/homeMenu.dart';

import '../../Client/Component/mainClientBody.dart';

class EmployeeBody extends StatefulWidget {
  // Widget? bodyContent = MainMenuBody();
  // MainMenuBody();
  // MainMenuBody.withData(this.bodyContent);
  @override
  _EmployeeBody createState() => _EmployeeBody();
}

class _EmployeeBody extends State<EmployeeBody> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  Widget bodyContent = EmployeeBody();
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mainBodyComponent(context);
  }

  Widget mainBodyComponent(context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.98,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            height: MediaQuery.of(context).size.height,
                            child:  UserCard()
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child:     ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: UIItem.menuItemLeftNested.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    String event = UIItem.menuItemLeftNested[index]["event"];
                                    switch(event) {
                                      case MENU_POS_MENU:
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (context) => HomeMenu()));
                                        break;
                                      case MENU_EOD:
                                        break;
                                      case MENU_LOGOUT:
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
                                            UIItem.menuItemLeftNested[index]["name"],
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

                      ),
                    ],
                  )
              ),

              //Product Man Section
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:  Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    height: MediaQuery.of(context).size.height * 0.98,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 6,
                            child: prodManLeftPanel()
                        ),
                        Expanded(
                            flex: 4,
                            child: prodManRightPanel()
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        )
      ],
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
  String dropdownValue = 'Search By Product Id';
  bool isChecked = false;
  Widget prodManLeftTopPanel() {
    return Row(
      children: [
        Expanded(
            flex: 8,
            child: Custom_ListTile_TextField(
                read: false,
                controller: null,
                labelText: "TEST LABEL",
                hintText: "TEST",
                isMask: false,
                mask: false
            )
        ),
        Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: dropdownValue,
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
              })
                  .toList(),
            )
        )
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
                labelText: "Description",
                hintText: "TEST",
                isMask: false,
                mask: false
            ),
            Custom_ListTile_TextField(
                read: false,
                controller: null,
                labelText: "Long Description",
                hintText: "TEST",
                isMask: false,
                mask: false
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child:  Custom_ListTile_TextField(
                        read: false,
                        controller: null,
                        labelText: "Product Id",
                        hintText: "TEST",
                        isMask: false,
                        mask: false
                    )
                ),
                Expanded(
                    flex: 3,
                    child:  Custom_ListTile_TextField(
                        read: false,
                        controller: null,
                        labelText: "Item Code",
                        hintText: "TEST",
                        isMask: false,
                        mask: false
                    )
                ),
                Expanded(
                    flex: 3,
                    child:  Custom_ListTile_TextField(
                        read: false,
                        controller: null,
                        labelText: "UPC",
                        hintText: "TEST",
                        isMask: false,
                        mask: false
                    )
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Custom_ListTile_TextField(
                          read: false,
                          controller: null,
                          labelText: "Cost",
                          hintText: "TEST",
                          isMask: false,
                          mask: false
                      ),
                      Custom_ListTile_TextField(
                          read: false,
                          controller: null,
                          labelText: "Price",
                          hintText: "TEST",
                          isMask: false,
                          mask: false
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Custom_ListTile_TextField(
                          read: false,
                          controller: null,
                          labelText: "Margin",
                          hintText: "TEST",
                          isMask: false,
                          mask: false
                      ),
                      Custom_ListTile_TextField(
                          read: false,
                          controller: null,
                          labelText: "Markup",
                          hintText: "TEST",
                          isMask: false,
                          mask: false
                      )
                    ],
                  ),
                )
              ],
            ),
            Custom_ListTile_TextField(
                read: false,
                controller: null,
                labelText: "User Note",
                hintText: "TEST",
                isMask: false,
                mask: false
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ListTile(
                          leading: Text("Department"),
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
                          leading: Text("Category"),
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
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ListTile(
                          leading: Text("Section"),
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
                          leading: Text("Supplier/Vendor"),
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
                  ),
                )
              ],
            ),

            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text("Discount Type - A"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: Text("Discount Type - B"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: Text("Discount Type - C"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: Text("Discount Type - D"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text("Tax Type - A"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: Text("Tax Type - B"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: Text("Tax Type - C"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: Text("Tax Type - D"),
                        title: Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            Row(
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
                    child:  solidButton("Update")
                )
              ],
            ),
          ],
        )
    ) ;
  }

  Widget prodManLeftBotPanel() {
    return Row(
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

  Widget solidButton(text) {
    return ListTile(
        title: ElevatedButton(
          // style: style,
          style: ElevatedButton.styleFrom(
              minimumSize: Size(0,50) // put the width and height you want
          ),
          onPressed: () {

          },
          child: Text(text),
        )
    ) ;
  }

}
