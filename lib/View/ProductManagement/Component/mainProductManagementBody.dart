// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UiEvent/menuEvent.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:provider/src/provider.dart';


class MainProductManagementBody extends StatefulWidget {
  UserModel? userData;
  MainProductManagementBody({Key? key, this.userData}) : super(key: key);
  @override
  _MainProductManagementBody createState() => _MainProductManagementBody();
}

class _MainProductManagementBody extends State<MainProductManagementBody> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  bool isLoading = false;
  String dropdownValue = 'Search By Product Id';
  bool isChecked = false;

  TextEditingController eTSearchTopBy = TextEditingController();
  TextEditingController eTDescription = TextEditingController();
  TextEditingController etDescription2 = TextEditingController();
  TextEditingController etDescription3 = TextEditingController();
  TextEditingController etProductUid = TextEditingController();
  TextEditingController etItemCode = TextEditingController();
  TextEditingController etUpc = TextEditingController();
  TextEditingController etCost =TextEditingController();
  TextEditingController etPrice = TextEditingController();
  TextEditingController etCreatedBy = TextEditingController();
  TextEditingController etUpdatedBy = TextEditingController();
  TextEditingController etMargin = TextEditingController();
  TextEditingController etMarkup = TextEditingController();


  int searchOptionValue = 1;
  Map<int, String> searchOptionByParam = <int, String>{
    0:"Search By Product Id",
    1:"Search By Item Code",
    2:"Search By Upc"
  };

  bool perReadOnly = true;
  bool readOnlyMode = true;
  int defaultProductMode = 0;
  Map<int, String> productMode = <int, String>{
    0:"Search",
    1:"Update",
    2:"Add"
  };

  String? itemCodeDefault;
  List<String>? itemCodeList = ["No Item Found"];

  bool isValidateOn = true;

  @override
  void initState() {
    super.initState();
    if(defaultProductMode != 0) {
      readOnlyMode = true;
    }
  }

  var formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  @override
  dispose() {
    super.dispose();

  }

  void appBaseEvent(MainState state) {
    // Executing Generic State
    if (state is GenericInitialState) {
      isLoading = false;
    } else if (state is GenericLoadingState) {
      isLoading = true;
    } else if (state is GenericErrorState) {
      isLoading = false;
      context.read<MainBloc>().add(MainParam.showSnackBar(eventStatus: MainEvent.Show_SnackBar, context: context, snackBarContent: state.error.toString()));
    }
  }

  void appSpecificEvent(MainState state) {
    // Executing Specific State
    if(state is ProductLoadingState) {
      isLoading = true;
    } else if (state is ProductLoadedState) {
      isLoading = false;
      parsingProductDataToUI(state.productModel!);
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 1, dropDownType: "PRODUCT-MODE-UPDATE-ITEM"));
    } else if (state is DropDownLoadedState) {
      if (state.dropDownType == "SEARCH-BY-MAP") {
        ConsolePrint("TICK", "SEARCH-BY-MAP");
        searchOptionValue = state.dropDownValue;
      } else if (state.dropDownType == "PRODUCT-MODE-NEW-ITEM") {
        ConsolePrint("TICK", "PRODUCT-MODE-NEW-ITEM");
        defaultProductMode = state.dropDownValue;
        clearProductDataUI();
      } else if (state.dropDownType == "PRODUCT-MODE-NEW-ITEM") {
        ConsolePrint("TICK", "SEARCH-BY-MAP");
        defaultProductMode = state.dropDownValue;
      } else if (state.dropDownType == "PRODUCT-MODE-UPDATE-ITEM" ) {
        if(mainProductModel != null) {
          formKey.currentState!.validate();
          ConsolePrint("TICK MODEL NOT NULL", "PRODUCT-MODE-UPDATE-ITEM");
        } else {
          ConsolePrint("TICK MODEL NULL", "PRODUCT-MODE-UPDATE-ITEM");
        }

        defaultProductMode = state.dropDownValue;
        // isValidateOn = false;
      }

      print("CHECK IS VALIDATE\t\t" + isValidateOn.toString());
    }
  }

  void clearProductDataUI() {
    String blank = "";
    eTDescription.text = blank;
    etCost.text = blank;
    etPrice.text = blank;
    etCreatedBy.text = blank;
    etUpdatedBy.text = blank;
    etProductUid.text = blank;
    etMargin.text = blank;
    etMarkup.text = blank;
    itemCodeList = ["No Item Found"];
    readOnlyMode = false;
    mainProductModel = null;
  }
  ProductModel? mainProductModel;
  void parsingProductDataToUI(ProductModel productModel) {
    mainProductModel = productModel;
    eTDescription.text = productModel.description!;
    etCost.text = productModel.cost.toString();
    etPrice.text = productModel.price!.toString();
    etCreatedBy.text = productModel.added_by! + " On " + productModel.added_datetime!;
    etUpdatedBy.text = productModel.updated_by == null ? "Not Available" : productModel.updated_by! + " On " + productModel.updated_by!;
    etProductUid.text = productModel.uid!;
    double? margin =  marginCalculation(productModel.price!, productModel.cost!);
    etMargin.text = margin.toString();
    double? markup = markupCalculation(productModel.price!, productModel.cost!);
    etMarkup.text = markup.toString();
    itemCodeList = productModel.itemCodeList!;
  }

  double marginCalculation(double price, double cost) {
    double? margin =  (price - cost) / price;
    return margin;
  }

  double markupCalculation(double price, double cost) {
    double? markup = (price - cost) / cost;
    return markup;
  }

  @override
  Widget build(BuildContext context) {
    //return mainBodyComponent(context);

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
      return mainBodyComponent(context);
    });
  }

  Widget mainBodyComponent(context) {
    return Form(
      key: formKey,
      child: Column(
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
                              child:  UserCard(userData: widget.userData)
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child:     ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      String event = UIItem.menuItemLeftNested[index]["event"];
                                      switch(event) {
                                        case MENU_POS_MENU:
                                          context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_MainMenu, context: context, userData: widget.userData));
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
            child: solidButton("NEW ITEM", "NEW-ITEM")
        ),

        Expanded(
          flex: 2,
          child: solidButton("Search", "SEARCH")
        ),
        Expanded(
            flex: 2,
            child: DropdownButton<int>(
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
              read: readOnlyMode,
              controller: eTDescription,
              labelText: "Description",
              hintText: "TEST",
              isMask: false,
              mask: false,
              validations: (value) {
                ConsolePrint(eTDescription.text, value);
                if(!isValidateOn) {
                  return null;
                } else if (eTDescription.text.isNotEmpty) {
                  return null;
                } else {
                  return "Please Provide Description";
                }
              },
          ),
          Custom_ListTile_TextField(
              read: readOnlyMode,
              controller: etDescription2,
              labelText: "Extended Description",
              hintText: "TEST",
              isMask: false,
              mask: false
          ),
          Custom_ListTile_TextField(
              read: readOnlyMode,
              controller: etDescription3,
              labelText: "User Note",
              hintText: "TEST",
              isMask: false,
              mask: false
          ),
          Custom_ListTile_TextField(
              read: readOnlyMode,
              controller: etProductUid,
              labelText: "Product Id",
              hintText: "TEST",
              isMask: false,
              mask: false
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child:  ListTile(
                      leading: const Text("Item Code"),
                      title:  DropdownButton<String>(
                        isExpanded: true,
                        value: itemCodeList![0],
                        style: const TextStyle(
                            color: Colors.deepPurple
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          print("VALUE DROP DOWN\t\t" + newValue!);
                        },
                        items: itemCodeList
                            ?.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                  ),
              ),
              Expanded(
                  flex: 2,
                  child:  defaultProductMode == 2 ? solidButton("Add ItemCode", "ADD-ITEM-CODE")  : solidButton("Modify ItemCode", "MODIFY-ITEM-CODE")
              ),
              Expanded(
                flex: 3,
                child:  ListTile(
                    leading: const Text("Upc"),
                    title:  DropdownButton<String>(
                      isExpanded: true,
                      value: itemCodeList![0],
                      style: const TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        print("VALUE DROP DOWN\t\t" + newValue!);
                      },
                      items: itemCodeList
                          ?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                ),
              ),
              Expanded(
                  flex: 2,
                  child:  defaultProductMode == 2 ? solidButton("Add Upc", "ADD-UPC")  : solidButton("Modify Upc", "MODIFY-UPC")
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etCost,
                        labelText: "Cost",
                        hintText: "TEST",
                        isMask: false,
                        mask: false,
                        validations: (value) {
                          if(!isValidateOn) {
                            return null;
                          } else if (etCost.text.isNotEmpty) {
                            return null;
                          } else {
                            return "Please Provide Item's Cost. Enter 0 if Item Does Not Have Cost";
                          }
                        },
                    ),
                    Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etPrice,
                        labelText: "Price",
                        hintText: "TEST",
                        isMask: false,
                        mask: false,
                        validations: (value) {
                          if(!isValidateOn) {
                            return null;
                          } else if (etPrice.text.isNotEmpty) {
                            return null;
                          } else {
                            return "Please Provide Price";
                          }
                        },
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etMargin,
                        labelText: "Margin",
                        hintText: "TEST",
                        isMask: false,
                        mask: false
                    ),
                    Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etMarkup,
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
                            print("VALUE DROP DOWN\t\t" + newValue!);
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
              Expanded(
                  flex: 3,
                  child:  defaultProductMode == 2 ? solidButton("Add To Batch", "ADD-SAVE-BATCH")  : solidButton("Save To Batch", "SAVE-BATCH")
              ),
              Expanded(
                  flex: 3,
                  child:  defaultProductMode == 2 ? solidButton("Add Batch", "ADD-BATCH") : solidButton("Update Batch", "UPDATE-BATCH")
              ),
              Expanded(
                  flex: 3,
                  child:  defaultProductMode == 2 ? solidButton("Add Item", "ADD-ITEM") : solidButton("Update Item", "UPDATE-ITEM")
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
        Expanded(
          flex: 5,
          child: Custom_ListTile_TextField(
              read: perReadOnly,
              controller: etCreatedBy,
              labelText: "Created By/Datetime",
              hintText: "TEST",
              isMask: false,
              mask: false
          )
        ),
        Expanded(
          flex: 5,
          child: Custom_ListTile_TextField(
              read: perReadOnly,
              controller: etUpdatedBy,
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
    return paginateTable();
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
    print("EVENT\t\t" + event);
    if(event == "SEARCH") {
      Map<String, String> map = Map<String, String>();
      if(searchOptionValue == 0) {
        String uid = eTSearchTopBy.text;
        map["uid"] = uid;
      } else if (searchOptionValue == 1) {
        String uid = eTSearchTopBy.text;
        map["itemCode"] = uid;
      } else if (searchOptionValue == 2) {
        String uid = eTSearchTopBy.text;
        map["upc"] = uid;
      } else {
        throw new Exception("Invalid Dropdown Value Selected");
      }
      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductByParamMap, userData: widget.userData, productParameter: map));
    } else if (event == "NEW-ITEM") {
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 2, dropDownType: "PRODUCT-MODE-NEW-ITEM"));
    } else if (event == "UPDATE-ITEM") {
      //ConsolePrint("TICK", "UPDATE-ITEM");
      //context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 1, dropDownType: "PRODUCT-MODE-UPDATE-ITEM"));
      if(formKey.currentState!.validate()) {
        print("UPDATE ITEM CLICK");
      }
    }
    // maybe redundant
    else if (event == "SEARCH-ITEM") {
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 0, dropDownType: "PRODUCT-MODE-SEARCH-ITEM"));
    }
    //
    else if (event == "ADD-ITEM") {

      if(formKey.currentState!.validate()) {
        print("ADD ITEM CLICK");
        addNewProductEvent();
      }

    }
  }

  void addNewProductEvent() {
    ProductModel model = ProductModel();
    model.description = eTDescription.text;
    model.second_description = etDescription2.text;
    model.third_description = etDescription3.text;
    model.cost = double.parse(etCost.text);
    model.price  = double.parse(etPrice.text);
    model.added_by = widget.userData?.uid;

    ConsolePrint("ADD MODEL", model.added_by);
  }

  DataTableSource _data = TableData();

  Widget paginateTable() {

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
      child: PaginatedDataTable(
        source: _data,
        header: Text('My Products'),
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price'))
        ],
        columnSpacing: 100,
        horizontalMargin: 10,
        rowsPerPage: 15,
        showCheckboxColumn: false,
      )
    );
  }
}


class TableData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "id": index,
        "title": "Item $index",
        "price": Random().nextInt(10000)
      });

  bool get isRowCountApproximate => false;
  int get rowCount => _data.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]["title"])),
      DataCell(Text(_data[index]["price"].toString())),
    ]);
  }
}