// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
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
import 'package:npos/Model/CategoryModel.dart';
import 'package:npos/Model/DepartmentModel.dart';
import 'package:npos/Model/DiscountModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/SectionModel.dart';
import 'package:npos/Model/TaxModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Model/VendorModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/Dialogs/ProductDialogBlocItemCode.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/Component/Stateful/customDialog.dart';
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
  bool isLoadingTable = false;
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

  
  double genericTextFieldMargin = 5;
  int searchOptionValue = 1;
  Map<int, String> searchOptionByParam = <int, String>{
    0:"Search By Product Id",
    1:"Search By Item Code",
    2:"Search By Upc",
    3:"Search By Description"
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

  String? discountDefault = "-1";
  Map<String, String> discountList = <String, String>{
    "-1":"Discount Not Found"
  };

  String? taxDefault = "-1";
  Map<String, String> taxList = <String, String>{
    "-1":"Tax Not Found"
  };

  String? departmentDefault = "-1";
  Map<String, String> departmentList = <String, String>{
    "-1":"Department Not Found"
  };
  String sectionDefault = "-1";
  Map<String, String> sectionList = <String, String>{
    "-1":"Section Not Found"
  };

  String? categoryDefault = "-1";
  Map<String, String> categoryList = <String, String>{
    "-1":"Category Not Found"
  };

  String? vendorDefault = "-1";
  Map<String, String> vendorList = <String, String>{
    "-1":"Category Not Found"
  };

  bool isValidateOn = true;

  List<ProductModel> listProductPaginate = [];
  @override
  void initState() {
    super.initState();
    if(defaultProductMode != 0) {
      readOnlyMode = true;
    }
    loadOnInit();
  }

  var formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  @override
  dispose() {
    super.dispose();

  }

  loadOnInit() {
    context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetAllDependency, userData: widget.userData, productParameter: {}));
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

  setDropDownData(Map<String, dynamic> response) {
    if(response["department"] != null) {
      departmentList = {};
      List<DepartmentModel> deptList = response["department"];
      for(int i = 0; i < deptList.length; i++) {
        if (i == 0) {
          departmentDefault = deptList[i].uid;
        }
        departmentList[deptList[i].uid!] = deptList[i].description!;
      }
      departmentList["-1"] = "Item Does Not Have Department";
    }

    if(response["category"] != null) {
      categoryList = {};
      List<CategoryModel> list = response["category"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          categoryDefault = list[i].uid;
        }
        categoryList[list[i].uid!] = list[i].description!;
      }
      categoryList["-1"] = "Item Does Not Have Category";
    }

    if(response["section"] != null) {
      sectionList = {};
      List<SectionModel> list = response["section"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          sectionDefault = list[i].uid!;
        }
        sectionList[list[i].uid!] = list[i].description!;
      }
      sectionList["-1"] = "Item Does Not Have Section";
    }

    if(response["vendor"] != null) {
      vendorList = {};
      List<VendorModel> list = response["vendor"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          vendorDefault = list[i].uid!;
        }
        vendorList[list[i].uid!] = list[i].description!;
      }
      vendorList["-1"] = "Item Does Not Have Vendor";
    }

    if(response["discount"] != null) {
      discountList = {};
      List<DiscountModel> list = response["discount"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          discountDefault = list[i].uid!;
        }
        discountList[list[i].uid!] = list[i].description! + " - " + list[i].rate.toString() + "%";
      }
      discountList["-1"] = "Item Does Not Have Discount";
    }

    if(response["tax"] != null) {
      taxList = {};
      List<TaxModel> list = response["tax"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          taxDefault = list[i].uid!;
        }
        taxList[list[i].uid!] = list[i].description! + " - " + list[i].rate.toString() + "%";
      }
      taxList["-1"] = "Item Does Not Have Tax";
    }
  }

  void app2ndGenericEvent(MainState state) {
    if (state is Generic2ndInitialState) {
    } else if (state is Generic2ndLoadingState) {
    } else if (state is Generic2ndLoadedState) {
      Map<String, dynamic> res = state.genericData;
      setDropDownData(res);
      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductPaginateCount, userData: widget.userData, productParameter: {"searchType": "test"}));
    } else if (state is Generic2ndErrorState) {

    }
  }

  void appProductEvent(MainState state) {
    if (state is ProductAddUpdateInitState) {

    } else if (state is ProductAddUpdateLoadingState) {

    } else if (state is ProductAddUpdateLoadedState) {

    } else if (state is ProductAddUpdateErrorState) {

    }
  }
  void appSpecificEvent(MainState state) {
    // Executing Specific State
    if(state is ProductLoadingState) {
      isLoading = true;
    } else if (state is ProductLoadedState) {
      readOnlyMode = false;
      isLoading = false;
      parsingProductDataToUI(state.productModel!);
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 1, dropDownType: "PRODUCT-MODE-UPDATE-ITEM"));
    } else if (state is DropDownLoadedState) {
      if (state.dropDownType == "SEARCH-BY-MAP") {
        searchOptionValue = state.dropDownValue;
      } else if (state.dropDownType == "DEPARTMENT-DROP-DOWN") {
        departmentDefault = state.dropDownValue;
      } else if (state.dropDownType == "CATEGORY-DROP-DOWN") {
        categoryDefault = state.dropDownValue;
      } else if (state.dropDownType == "SECTION-DROP-DOWN") {
        sectionDefault = state.dropDownValue;
      } else if (state.dropDownType == "VENDOR-DROP-DOWN") {
        vendorDefault = state.dropDownValue;
      } else if (state.dropDownType == "DISCOUNT-DROP-DOWN") {
        discountDefault = state.dropDownValue;
      } else if (state.dropDownType == "TAX-DROP-DOWN") {
        taxDefault = state.dropDownValue;
      }

      else if (state.dropDownType == "PRODUCT-MODE-NEW-ITEM") {
        // ADD NEW ITEM MODE LOGIC
        addNewItemMode(state.dropDownValue);
      } else if (state.dropDownType == "PRODUCT-MODE-NEW-ITEM") {
        defaultProductMode = state.dropDownValue;
      } else if (state.dropDownType == "PRODUCT-MODE-UPDATE-ITEM" ) {
        // UPDATE ITEM MODE LOGIC
        if(mainProductModel != null) {
          // UPDATE ITEM MODE WHERE PRODUCT MODEL IS NOT NULL
          formKey.currentState!.validate();
        } else {
          // UPDATE ITEM MODE WHERE PRODUCT MODEL IS NULL
        }
        updateItemMode(state.dropDownValue);
      }
    }  else if (state is ProductPaginateLoadingState) {
      isLoadingTable = true;
    } else if (state is ProductPaginateLoadedState) {
      isLoadingTable = false;
      listProductPaginate = state.listProductModel!;
    } else if (state is ProductPaginateCountLoadedState) {
      isLoadingTable = false;
      // Invoke Load Paginate Product After Count is Completed
      DataCount = state.count!;
      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductPaginate, userData: widget.userData, productParameter: {
        "searchType": "test",
        "startIdx": 1,
        "endIdx": 10
      }));
    }
  }

  int DataCount = 0;

  // ADD NEW ITEM LOGIC
  void addNewItemMode(int productMode) {
    defaultProductMode = productMode;
    clearProductDataUI();
    etProductUid.text = "Product Id Will Automatically Be Generated";
    departmentList["-1"] = "Select Product Department";
    sectionList["-1"] = "Select Product Section";
    categoryList["-1"] = "Select Product Category";
    vendorList["-1"] = "Select Product Vendor";
    discountList["-1"] = "Select Product Discount";
    taxList["-1"] = "Select Product Tax";
  }

  // UPDATE ITEM LOGIC
  void updateItemMode(int productMode) {
    departmentList["-1"] = "Product Doesn't Have Department";
    sectionList["-1"] = "Product Doesn't Have Section";
    categoryList["-1"] = "Product Doesn't Have Category";
    vendorList["-1"] = "Product Doesn't Have Vendor";
    discountList["-1"] = "Product Doesn't Have Discount";
    taxList["-1"] = "Product Doesn't Have Tax";
    defaultProductMode = productMode;
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
    departmentDefault = "-1";
    sectionDefault = "-1";
    categoryDefault = "-1";
    vendorDefault = "-1";
    discountDefault = "-1";
    taxDefault = "-1";
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

    if ( productModel.itemCodeList.isNotEmpty) {
      itemCodeList = productModel.itemCodeList;
      mainProductModel?.itemCode = int.parse(itemCodeList![0]);
    } else {
      itemCodeList =  ["No Item Found"];
      mainProductModel?.itemCode = -1;
    }

    if ( productModel.departmentList.isNotEmpty) {
      departmentDefault = productModel.departmentList[0].toString();
    } else {
      departmentDefault =  "-1";
    }

    if ( productModel.sectionList.isNotEmpty) {
      sectionDefault = productModel.sectionList[0].toString();
    } else {
      sectionDefault =  "-1";
    }

    if ( productModel.categoryList.isNotEmpty) {
      categoryDefault = productModel.categoryList[0].toString();
    } else {
      categoryDefault =  "-1";
    }

    if ( productModel.vendorList.isNotEmpty) {
      vendorDefault = productModel.vendorList[0].toString();
    } else {
      vendorDefault =  "-1";
    }

    if ( productModel.discountList.isNotEmpty) {
      discountDefault = productModel.discountList[0].toString();
    } else {
      discountDefault =  "-1";
    }

    if ( productModel.taxList.isNotEmpty) {
      taxDefault = productModel.taxList[0].toString();
    } else {
      taxDefault =  "-1";
    }
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
      app2ndGenericEvent(state);
      appSpecificEvent(state);
      appProductEvent(state);
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
                labelText: "Search Text",
                hintText: "Enter Your Search Text Here",
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
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(genericTextFieldMargin),
            child: Custom_ListTile_TextField(
              read: readOnlyMode,
              controller: eTDescription,
              labelText: "Description",
              hintText: "Enter Description",
              isMask: false, isNumber:false,
              mask: false,
              validations: (value) {
                if(!isValidateOn) {
                  return null;
                } else if (eTDescription.text.isNotEmpty) {
                  return null;
                } else {
                  return "Please Provide Description";
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(genericTextFieldMargin),
            child:
            Custom_ListTile_TextField(
                read: readOnlyMode,
                controller: etDescription2,
                labelText: "Extended Description",
                hintText: "Enter Extended Description",
                isMask: false, isNumber:false,
                mask: false,
                maxLines: 3,
            ),
          ),
          Container(
            margin: EdgeInsets.all(genericTextFieldMargin),
            child: Custom_ListTile_TextField(
                read: readOnlyMode,
                controller: etDescription3,
                labelText: "User Note",
                hintText: "Enter User Note",
                isMask: false, isNumber:false,
                mask: false,
              maxLines: 3,
            ),
          ),
          Container(
            margin: EdgeInsets.all(genericTextFieldMargin),
            child:  Custom_ListTile_TextField(
                read: true,
                controller: etProductUid,
                labelText: "Product Id",
                hintText: "Product Id Will Be Generated By The System",
                isMask: false, isNumber:false,
                mask: false
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: defaultProductMode ==  2 ? 5 : 3,
                  child:  ListTile(
                      leading: const Text("Item Code"),
                      title:
                      defaultProductMode ==  2 ? Custom_ListTile_TextField(
                        controller: etItemCode,
                          read: false,
                          labelText: "Item Code",
                          hintText: "Enter Item Code",
                          isMask: false, isNumber:false,
                          mask: false
                      ) :
                      DropdownButton<String>(
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
              defaultProductMode ==  2 ? SizedBox() : Expanded(
                  flex: 2,
                  child:  defaultProductMode == 2 ? solidButton("Add ItemCode", "ADD-ITEM-CODE")  : solidButton("Modify ItemCode", "MODIFY-ITEM-CODE")
              ),
              Expanded(
                flex:  defaultProductMode ==  2 ? 5 : 3,
                child:  ListTile(
                    leading: const Text("Upc"),
                    title:   defaultProductMode ==  2 ? Custom_ListTile_TextField(
                      controller: etUpc,
                        read: false,
                        labelText: "Upc",
                        hintText: "Enter Upc",
                        isMask: false, isNumber:false,
                        mask: false
                    ) : DropdownButton<String>(
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
              defaultProductMode ==  2 ? SizedBox() : Expanded(
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
                    Container(
                      margin: EdgeInsets.all(genericTextFieldMargin),
                      child: Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etCost,
                        labelText: "Cost",
                        hintText: "Enter Cost, Require format is (##.#)",
                        isMask: false, isNumber:true,
                        mask: false,
                        onChange: (text) {
                          textFieldOnChangeEvent("COST", text);
                        },
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
                    ),
                    Container(
                      margin: EdgeInsets.all(genericTextFieldMargin),
                      child: Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etPrice,
                        labelText: "Price",
                        hintText: "Enter Price, Require format is (##.#)",
                        isMask: false, isNumber:true,
                        mask: false,
                        onChange: (text) {
                          textFieldOnChangeEvent("PRICE", text);
                        } ,
                        validations: (value) {
                          if(!isValidateOn) {
                            return null;
                          } else if (etPrice.text.isNotEmpty) {
                            return null;
                          } else {
                            return "Please Provide Price";
                          }
                        },
                      ),
                    ),


                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(genericTextFieldMargin),
                      child:  Custom_ListTile_TextField(
                          read: readOnlyMode,
                          controller: etMargin,
                          labelText: "Margin",
                          hintText: "Enter Expected Margin, Require format is (##.#)",
                          isMask: false, isNumber:true,
                          mask: false,
                          onChange: (text) {
                            textFieldOnChangeEvent("MARGIN", text);
                          } ,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(genericTextFieldMargin),
                      child:  Custom_ListTile_TextField(
                          read: readOnlyMode,
                          controller: etMarkup,
                          labelText: "Markup",
                          hintText: "Enter Expected Markup, Require format is (##.#)",
                          isMask: false, isNumber:true,
                          mask: false,
                          onChange: (text) {
                            textFieldOnChangeEvent("MARKUP", text);
                          } ,
                      ),
                    ),


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
                        leading: const Text("Department"),
                        title:  DropdownButton<String>(
                          isExpanded: true,
                          value: departmentDefault,
                          style: const TextStyle(
                              color: Colors.deepPurple
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "DEPARTMENT-DROP-DOWN"));
                          },
                          items: departmentList
                              .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(value),
                                ));
                          }).values.toList(),
                        )
                    ),
                    ListTile(
                        leading: const Text("Category"),
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
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "CATEGORY-DROP-DOWN"));
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
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    ListTile(
                        leading: const Text("Section"),
                        title:  DropdownButton<String>(
                          isExpanded: true,
                          value: sectionDefault,
                          style: const TextStyle(
                              color: Colors.deepPurple
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "SECTION-DROP-DOWN"));
                          },
                          items: sectionList
                              .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(value),
                                ));
                          }).values.toList(),
                        )
                    ),
                    ListTile(
                        leading: const Text("Vendor"),
                        title:  DropdownButton<String>(
                          isExpanded: true,
                          value: vendorDefault,
                          style: const TextStyle(
                              color: Colors.deepPurple
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "VENDOR-DROP-DOWN"));
                          },
                          items: vendorList
                              .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(value),
                                ));
                          }).values.toList(),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),

          Row(
            children: [
              Expanded(
                flex: 5,
                child:  ListTile(
                    leading: const Text("Discount"),
                    title:  DropdownButton<String>(
                      isExpanded: true,
                      value: discountDefault,
                      style: const TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "DISCOUNT-DROP-DOWN"));
                      },
                      items: discountList
                          .map((key, value) {
                        return MapEntry(
                            key,
                            DropdownMenuItem<String>(
                              value: key,
                              child: Text(value),
                            ));
                      }).values.toList(),
                    )
                ),
              ),
              Expanded(
                flex: 5,
                child:  ListTile(
                    leading: const Text("Tax"),
                    title:  DropdownButton<String>(
                      isExpanded: true,
                      value: taxDefault,
                      style: const TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: "TAX-DROP-DOWN"));
                      },
                      items: taxList
                          .map((key, value) {
                        return MapEntry(
                            key,
                            DropdownMenuItem<String>(
                              value: key,
                              child: Text(value),
                            ));
                      }).values.toList(),
                    )
                ),
              ),
            ],
          ),

        ],
      )
    ) ;
  }

  Widget prodManLeftBotPanel() {
    return
      Column(
        children: [
          Expanded(
            flex: 5,
              child:
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child:  SizedBox()//defaultProductMode == 2 ? solidButton("Add To Batch", "ADD-SAVE-BATCH")  : solidButton("Save To Batch", "SAVE-BATCH")
                  ),
                  Expanded(
                      flex: 3,
                      child:  SizedBox()//defaultProductMode == 2 ? solidButton("Add Batch", "ADD-BATCH") : solidButton("Update Batch", "UPDATE-BATCH")
                  ),
                  Expanded(
                      flex: 3,
                      child:  defaultProductMode == 2 ? solidButton("Add Item", "ADD-ITEM") : solidButton("Update Item", "UPDATE-ITEM")
                  )
                ],
              ),
          ),
          Expanded(
            flex: 5,
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Custom_ListTile_TextField(
                          read: perReadOnly,
                          controller: etCreatedBy,
                          labelText: "Created By/Datetime",
                          isMask: false, isNumber:false,
                          mask: false
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Custom_ListTile_TextField(
                          read: perReadOnly,
                          controller: etUpdatedBy,
                          labelText: "Last Updated By/Datetime",
                          isMask: false, isNumber:false,
                          mask: false
                      )
                  )
                ],
              ))
        ],
      );
  }

  Widget prodManRightPanel() {
    return isLoadingTable ?  ShareSpinner() : paginateTable();
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


  void textFieldOnChangeEvent(String event, String text) {
    // DO THE IF LOGIC HERE
    if (event == "PRICE") {
      etCost.text = "6969";
    } else if (event == "COST") {

    } else if (event == "MARKUP") {
      calculateRevenueGivenMarkup();
    } else if (event == "MARGIN") {
      calculateRevenueGivenMargin();
    } else {

    }

  }

  void calculateRevenueGivenMargin() {
      double margin = double.parse(etMargin.text);
      double cost = double.parse(etCost.text);
      double step1 = 1 - (margin / 100);
      double step2 = cost / step1;
      etPrice.text = step2.toString();
      calculateMarkupGivenCostAndPrice();
  }

  void calculateMarginGivenCostAndPrice() {
      double cost = double.parse(etCost.text);
      double price =double.parse(etPrice.text);
      double step1 = 100 * (price - cost) / price;
      etMargin.text = step1.toString();
  }

  void calculateRevenueGivenMarkup() {
      double markup = double.parse(etMarkup.text);
      double cost = double.parse(etCost.text);
      double step1 = (1 + (markup / 100)) * cost;
      etPrice.text = step1.toString();
      calculateMarginGivenCostAndPrice();
  }

  void calculateMarkupGivenCostAndPrice() {

    /*
    * (price / cost) - 1 = markup
    * */
    double cost = double.parse(etCost.text);
    double price =double.parse(etPrice.text);
    double step1 = ((price / cost) - 1) * 100;
    etMarkup.text = step1.toString();
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
      if(formKey.currentState!.validate()) {
        updateProductEvent();
      }
    } else if (event == "SEARCH-ITEM") {
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 0, dropDownType: "PRODUCT-MODE-SEARCH-ITEM"));
    } else if (event == "ADD-ITEM") {

      if(formKey.currentState!.validate()) {
        addNewProductEvent();
      }
    } else if (event == "MODIFY-ITEM-CODE") {
      context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_ItemCode_Update
          , userData: widget.userData, productData: mainProductModel, context: context));
    } else if (event == "ADD-ITEM-CODE") {
      context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_ItemCode_Add
          , userData: widget.userData, productData: mainProductModel, context: context));
    }
  }

  void updateProductEvent() {
    mainProductModel?.description = eTDescription.text;
    mainProductModel?.second_description = etDescription2.text;
    mainProductModel?.third_description = etDescription3.text;
    mainProductModel?.cost = double.parse(etCost.text);
    mainProductModel?.price  = double.parse(etPrice.text);
    mainProductModel?.updated_by = widget.userData?.uid;

    mainProductModel?.departmentList = <String>[];
    mainProductModel?.sectionList = <String>[];
    mainProductModel?.categoryList = <String>[];
    mainProductModel?.vendorList = <String>[];
    mainProductModel?.discountList = <String>[];
    mainProductModel?.taxList = <String>[];

    if(departmentDefault != '-1') {
      mainProductModel?.departmentList.add(departmentDefault!);
    }

    if(sectionDefault != '-1') {
      mainProductModel?.sectionList.add(sectionDefault);
    }

    if(categoryDefault != '-1') {
      mainProductModel?.categoryList.add(categoryDefault!);
    }

    if(vendorDefault != '-1') {
      mainProductModel?.vendorList.add(vendorDefault!);
    }

    if(discountDefault != '-1') {
      mainProductModel?.discountList.add(discountDefault!);
    }

    if(taxDefault != '-1') {
      mainProductModel?.taxList.add(taxDefault!);
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

    model.itemCodeList = <String>[];
    model.upcList = <String>[];
    model.departmentList = <String>[];
    model.sectionList = <String>[];
    model.categoryList = <String>[];
    model.vendorList = <String>[];
    model.discountList = <String>[];
    model.taxList = <String>[];

    if(etItemCode.text.isNotEmpty) {
      model.itemCodeList.add(etItemCode.text);
    }

    if(etUpc.text.isNotEmpty) {
      model.upcList?.add(etUpc.text);
    }

    if(departmentDefault != '-1') {
      model.departmentList.add(departmentDefault!);
    }

    if(sectionDefault != '-1') {
     model.sectionList.add(sectionDefault);
    }

    if(categoryDefault != '-1') {
      model.categoryList.add(categoryDefault!);
    }

    if(vendorDefault != '-1') {
      model.vendorList.add(vendorDefault!);
    }

    if(discountDefault != '-1') {
      model.discountList.add(discountDefault!);
    }

    if(taxDefault != '-1') {
      model.taxList.add(taxDefault!);
    }

    context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Add
        , userData: widget.userData, productData: model, context: context));

   // context.read<MainBloc>().add(MainParam.AddProduct(eventStatus: MainEvent.Event_AddProduct, productData: model, locationId: widget.userData?.defaultLocation?.uid));
  }

  Widget paginateTable() {
    DataTableSource _data = TableData(listProductPaginate, DataCount, context, widget.userData);
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

}


class TableData extends DataTableSource {
  BuildContext context;
  dynamic userData;
  int dataCount = 0;
  List<ProductModel> lstProductModel = [];
  TableData(this.lstProductModel, this.dataCount, this.context, this.userData);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => lstProductModel.length ;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow2(
      onLongPress: () {
        ProductModel selectedModel = lstProductModel[index];
        Map<String, String> map = <String, String>{};
        map["uid"] = selectedModel.uid!;
        context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductByParamMap, userData: userData, productParameter: map));
      },
        cells: [
          DataCell(Text(lstProductModel[index].uid.toString())),
          DataCell(Text(lstProductModel[index].description.toString())),
          DataCell(Text(lstProductModel[index].price.toString())),
          DataCell(Text(lstProductModel[index].cost.toString())),
        ]
    );
  }
}