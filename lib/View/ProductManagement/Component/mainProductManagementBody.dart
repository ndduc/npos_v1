// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: must_be_immutable
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/Product/ProductShareUIValues.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UIEvent/addProductEvent.dart';
import 'package:npos/Constant/UIEvent/menuEvent.dart';
import 'package:npos/Constant/Values/MapValues.dart';
import 'package:npos/Constant/Values/NumberValues.dart';
import 'package:npos/Constant/Values/StringValues.dart';
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
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';


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
  String? dropdownValue = PRODUCT_SEARCH_OPTION[0];
  bool isChecked = false;

  String eTSearchTopByOld = "";
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
  int searchOptionValueOld = -1;
  Map<int, String> searchOptionByParam = PRODUCT_SEARCH_OPTION;

  bool perReadOnly = true;
  bool readOnlyMode = true;
  int defaultProductMode = 0;
  Map<int, String> productMode = PRODUCT_MODE;

  String? upcDefault = STRING_NULL;
  String? upcDefaultValue;
  List<String>? upcList = [UPC + WHITE_SPACE + STRING_NOT_FOUND];

  String? itemCodeDefault = STRING_NULL;
  String? itemCodeDefaultValue;
  List<String>? itemCodeList = [ITEMCODE + WHITE_SPACE + STRING_NOT_FOUND];

  String? discountDefault = STRING_NULL;
  String? discountDefaultValue;
  Map<String, String> discountList = <String, String>{
    STRING_NULL: DISCOUNT + WHITE_SPACE + STRING_NOT_FOUND
  };

  String? taxDefault = STRING_NULL;
  String? taxDefaultValue;
  Map<String, String> taxList = <String, String>{
    STRING_NULL: TAX + WHITE_SPACE + STRING_NOT_FOUND
  };

  String? departmentDefault = STRING_NULL;
  String? departmentDefaultValue;
  Map<String, String> departmentList = <String, String>{
    STRING_NULL: DEPARTMENT + WHITE_SPACE + STRING_NOT_FOUND
  };
  String? sectionDefault = STRING_NULL;
  String? sectionDefaultValue;
  Map<String, String> sectionList = <String, String>{
    STRING_NULL: SECTION + WHITE_SPACE + STRING_NOT_FOUND
  };

  String? categoryDefault = STRING_NULL;
  String? categoryDefaultValue;
  Map<String, String> categoryList = <String, String>{
    STRING_NULL: CATEGORY + WHITE_SPACE + STRING_NOT_FOUND
  };

  String? vendorDefault = STRING_NULL;
  String? vendorDefaultValue;
  Map<String, String> vendorList = <String, String>{
    STRING_NULL: VENDOR + WHITE_SPACE + STRING_NOT_FOUND
  };

  bool isValidateOn = true;
  int DataCount = 0;
  List<ProductModel> listProductPaginate = [];
  var formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  ProductModel? mainProductModel;

  @override
  void initState() {
    super.initState();
    if(defaultProductMode != 0) {
      readOnlyMode = true;
    }
    loadOnInit();
  }

  @override
  dispose() {
    super.dispose();

  }

  loadOnInit() {
    context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetAllDependency, userData: widget.userData, productParameter: { "searchText": "" }));
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
      departmentList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + DEPARTMENT;
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
      categoryList[STRING_NULL] =  STRING_NOT_HAVE + WHITE_SPACE + CATEGORY;
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
      sectionList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + SECTION;
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
      vendorList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + VENDOR;
    }

    if(response["discount"] != null) {
      discountList = {};
      List<DiscountModel> list = response["discount"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          discountDefault = list[i].uid!;
        }
        discountList[list[i].uid!] = list[i].description! + WHITE_SPACE + DASH + WHITE_SPACE + list[i].rate.toString() + PERCENT;
      }
      discountList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + DISCOUNT;
    }

    if(response["tax"] != null) {
      taxList = {};
      List<TaxModel> list = response["tax"];
      for(int i = 0; i < list.length; i++) {
        if (i == 0) {
          taxDefault = list[i].uid!;
        }
        taxList[list[i].uid!] = list[i].description! + WHITE_SPACE + DASH + WHITE_SPACE + list[i].rate.toString() + PERCENT;
      }
      taxList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + TAX;
    }
  }

  void app2ndGenericEvent(MainState state) {
    if (state is Generic2ndInitialState) {
    } else if (state is Generic2ndLoadingState) {
    } else if (state is Generic2ndLoadedState) {
      Map<String, dynamic> res = state.genericData;
      setDropDownData(res);
      Map<String, dynamic> param = {
        "searchText":"",
        "uid":"",
        "upc":"",
        "itemCode":""
      };
      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductPaginateCount, userData: widget.userData, productParameter: param));
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

  void appDialogEvent(MainState state) {
    if (state is DialogProductAddUpdateInitState) {
      ConsolePrint("STATE", "INIT");
    } else if (state is DialogProductAddUpdateLoadingState) {
      ConsolePrint("STATE", "LOADING");
    } else if (state is DialogProductAddUpdateLoadedState) {
      if (state.sucess) {
        clearProductDataUI();
      } else {

      }
      ConsolePrint("STATE", state.response);

    } else if (state is DialogProductAddUpdateErrorState) {
      ConsolePrint("STATE", state.error);
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
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 1, dropDownType: EVENT_MODE_PRODUCT_UPDATE));
    } else if (state is DropDownLoadedState) {
      if (state.dropDownType == EVENT_DROPDOWN_SEARCH_MAP) {
        searchOptionValue = state.dropDownValue;
      } else if (state.dropDownType == EVENT_DROPDOWN_DEPARTMENT) {
        departmentDefault = state.dropDownValue;
      } else if (state.dropDownType == EVENT_DROPDOWN_CATEGORY) {
        categoryDefault = state.dropDownValue;
      } else if (state.dropDownType == EVENT_DROPDOWN_SECTION) {
        sectionDefault = state.dropDownValue;
      } else if (state.dropDownType == EVENT_DROPDOWN_VENDOR) {
        vendorDefault = state.dropDownValue;
      } else if (state.dropDownType == EVENT_DROPDOWN_DISCOUNT) {
        discountDefault = state.dropDownValue;
      } else if (state.dropDownType == EVENT_DROPDOWN_TAX) {
        taxDefault = state.dropDownValue;
      }

      else if (state.dropDownType == EVENT_MODE_NEW_ITEM) {
        // ADD NEW ITEM MODE LOGIC
        addNewItemMode(state.dropDownValue);
      } else if (state.dropDownType == EVENT_MODE_NEW_ITEM) {
        defaultProductMode = state.dropDownValue;
      } else if (state.dropDownType == EVENT_MODE_PRODUCT_UPDATE ) {
        // UPDATE ITEM MODE LOGIC
        if(mainProductModel != null) {
          // UPDATE ITEM MODE WHERE PRODUCT MODEL IS NOT NULL
          formKey.currentState!.validate();
        } else {
          // UPDATE ITEM MODE WHERE PRODUCT MODEL IS NULL
        }
        updateItemMode(state.dropDownValue);

        Map<String, dynamic> map = <String, dynamic>{
          "searchText" : "",
          "uid" : "",
          "itemCode" : "",
          "upc" : "",
        };
        if (eTSearchTopByOld != eTSearchTopBy.text || searchOptionValueOld != searchOptionValue) {
          if (searchOptionValue == 3 ) {
            map["searchText"] = eTSearchTopBy.text;
          } else if (searchOptionValue == 0) {
            map["uid"] = eTSearchTopBy.text;
          } else if (searchOptionValue == 1) {
            map["itemCode"] = eTSearchTopBy.text;
          } else if (searchOptionValue == 2) {
            map["upc"] = eTSearchTopBy.text;
          }
          eTSearchTopByOld = eTSearchTopBy.text;
          searchOptionValueOld = searchOptionValue;
          context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductPaginateCount, userData: widget.userData, productParameter: map));
        }
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

      Map<String, dynamic> map = <String, dynamic>{
        "startIdx": 1,
        "endIdx": 10,
        "searchText":"",
        "uid":"",
        "upc":"",
        "itemCode":""
      };
      if (searchOptionValue == 3) {
        map["searchText"] = eTSearchTopBy.text;
      } else if (searchOptionValue == 0){
        map["uid"] = eTSearchTopBy.text;
      } else if (searchOptionValue == 1){
        map["itemCode"] = eTSearchTopBy.text;
      } else if (searchOptionValue == 2){
        map["upc"] = eTSearchTopBy.text;
      }

      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductPaginate, userData: widget.userData, productParameter: map));
    }
  }

  // ADD NEW ITEM LOGIC
  void addNewItemMode(int productMode) {
    defaultProductMode = productMode;
    clearProductDataUI();
    etProductUid.text = PRODUCT_ID;
    departmentList[STRING_NULL] = SELECT_ITEM + WHITE_SPACE + DEPARTMENT;
    sectionList[STRING_NULL] = SELECT_ITEM + WHITE_SPACE + SECTION;
    categoryList[STRING_NULL] = SELECT_ITEM + WHITE_SPACE + CATEGORY;
    vendorList[STRING_NULL] = SELECT_ITEM + WHITE_SPACE + VENDOR;
    discountList[STRING_NULL] = SELECT_ITEM + WHITE_SPACE + DISCOUNT;
    taxList[STRING_NULL] = SELECT_ITEM + WHITE_SPACE + TAX;
  }

  // UPDATE ITEM LOGIC
  void updateItemMode(int productMode) {
    departmentList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + DEPARTMENT;
    sectionList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + SECTION;
    categoryList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + CATEGORY;
    vendorList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + VENDOR;
    discountList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + DISCOUNT;
    taxList[STRING_NULL] = STRING_NOT_HAVE + WHITE_SPACE + TAX;
    defaultProductMode = productMode;
  }

  void clearProductDataUI() {
    eTDescription.text = EMPTY;
    etDescription2.text = EMPTY;
    etDescription3.text = EMPTY;
    etCost.text = EMPTY;
    etPrice.text = EMPTY;
    etCreatedBy.text = EMPTY;
    etUpdatedBy.text = EMPTY;
    etProductUid.text = EMPTY;
    etItemCode.text = EMPTY;
    etUpc.text = EMPTY;
    etMargin.text = EMPTY;
    etMarkup.text = EMPTY;
    itemCodeList = [ITEM_NOT_FOUND];
    upcList = [ITEM_NOT_FOUND];
    readOnlyMode = false;
    mainProductModel = null;

    departmentDefaultValue = EMPTY;
    departmentDefault = STRING_NULL;
    sectionDefaultValue = EMPTY;
    sectionDefault = STRING_NULL;
    categoryDefaultValue = EMPTY;
    categoryDefault = STRING_NULL;
    vendorDefaultValue = EMPTY;
    vendorDefault = STRING_NULL;
    discountDefaultValue = EMPTY;
    discountDefault = STRING_NULL;
    taxDefaultValue = EMPTY;
    taxDefault = STRING_NULL;
    itemCodeDefaultValue = EMPTY;
    upcDefaultValue = EMPTY;
  }

  void parsingProductDataToUI(ProductModel productModel) {
    mainProductModel = productModel;
    if (!productModel.isEmpty) {
      eTDescription.text = productModel.description!;
      etDescription2.text = productModel.second_description!;
      etDescription3.text = productModel.third_description!;
      etCost.text = productModel.cost.toString();
      etPrice.text = productModel.price!.toString();
      etCreatedBy.text = productModel.added_by! + " On " + productModel.added_datetime!;
      etUpdatedBy.text = productModel.updated_by == null ? NOT_AVAILABLe : productModel.updated_by! + " On " + productModel.updated_by!;
      etProductUid.text = productModel.uid!;
      double? margin =  marginCalculation(productModel.price!, productModel.cost!);
      etMargin.text = margin.toString();
      double? markup = markupCalculation(productModel.price!, productModel.cost!);
      etMarkup.text = markup.toString();

      if ( productModel.itemCodeList.isNotEmpty) {
        itemCodeList = productModel.itemCodeList;
        mainProductModel?.itemCode = int.parse(itemCodeList![0]);
      } else {
        itemCodeList =  [ITEM_NOT_FOUND];
        mainProductModel?.itemCode = NUMBER_NULL;
      }

      if ( productModel.upcList.isNotEmpty) {
        upcList = productModel.upcList;
        mainProductModel?.upc = NUMBER_NOT_NULL;
        mainProductModel?.str_upc = upcList![0].toString();
      } else {
        upcList =  [ITEM_NOT_FOUND];
        mainProductModel?.upc = NUMBER_NULL;
      }

      if ( productModel.departmentList.isNotEmpty) {
        departmentDefault = productModel.departmentList[0].toString();
      } else {
        departmentDefault =  STRING_NULL;
      }

      if ( productModel.sectionList.isNotEmpty) {
        sectionDefault = productModel.sectionList[0].toString();
      } else {
        sectionDefault =  STRING_NULL;
      }

      if ( productModel.categoryList.isNotEmpty) {
        categoryDefault = productModel.categoryList[0].toString();
      } else {
        categoryDefault =  STRING_NULL;
      }

      if ( productModel.vendorList.isNotEmpty) {
        vendorDefault = productModel.vendorList[0].toString();
      } else {
        vendorDefault =  STRING_NULL;
      }

      if ( productModel.discountList.isNotEmpty) {
        discountDefault = productModel.discountList[0].toString();
      } else {
        discountDefault =  STRING_NULL;
      }

      if ( productModel.taxList.isNotEmpty) {
        taxDefault = productModel.taxList[0].toString();
      } else {
        taxDefault =  STRING_NULL;
      }
    } else {
      clearProductDataUI();
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
      appDialogEvent(state);
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
            child: solidButton(BTN_NEW_ITEM, EVENT_NEW_ITEM)
        ),
        Expanded(
          flex: 2,
          child: solidButton(BTN_SEARCH, EVENT_SEARCH)
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
               context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_SEARCH_MAP));
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
                labelText: TXT_SEARCH_TEXT,
                hintText: HINT_SEARCH_TEXT,
                isMask: false,
                isNumber:false,
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
            margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
            child: Custom_ListTile_TextField(
              read: readOnlyMode,
              controller: eTDescription,
              labelText: TXT_DESCRIPTION,
              hintText: HINT_DESCRIPTION,
              isMask: false,
              isNumber:false,
              mask: false,
              validations: (value) {
                if(!isValidateOn) {
                  return null;
                } else if (eTDescription.text.isNotEmpty) {
                  return null;
                } else {
                  return VALIDATE_DESCRIPTION;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
            child:
            Custom_ListTile_TextField(
                read: readOnlyMode,
                controller: etDescription2,
                labelText: TXT_DESCRIPTION_2,
                hintText: HINT_DESCRIPTION_2,
                isMask: false,
                isNumber:false,
                mask: false,
                maxLines: 3,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
            child: Custom_ListTile_TextField(
                read: readOnlyMode,
                controller: etDescription3,
                labelText: TXT_DESCRIPTION_3,
                hintText: HINT_DESCRIPTION_3,
                isMask: false,
                isNumber:false,
                mask: false,
              maxLines: 3,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
            child:  Custom_ListTile_TextField(
                read: true,
                controller: etProductUid,
                labelText: TXT_PRODUCT_ID,
                hintText: HINT_PRODUCT_ID,
                isMask: false,
                isNumber:false,
                mask: false
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: defaultProductMode ==  2 ? 5 : 3,
                  child:  ListTile(
                      leading: const Text(TXT_ITEMCODE),
                      title:
                      defaultProductMode ==  2 ? Custom_ListTile_TextField(
                        controller: etItemCode,
                          read: false,
                          labelText: TXT_ITEMCODE,
                          hintText: HINT_ITEMCODE,
                          isMask: false,
                          isNumber:false,
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
              defaultProductMode ==  2 ? const SizedBox() : Expanded(
                  flex: 2,
                  child:  defaultProductMode == 2 ? solidButton(BTN_ADD_ITEMCODE, EVENT_ITEMCODE_ADD)  : solidButton(BTN_UPDATE_ITEMCODE, EVENT_ITEMCODE_UPDATE)
              ),
              Expanded(
                flex:  defaultProductMode ==  2 ? 5 : 3,
                child:  ListTile(
                    leading: const Text(TXT_UPC),
                    title:   defaultProductMode ==  2 ? Custom_ListTile_TextField(
                      controller: etUpc,
                        read: false,
                        labelText: TXT_UPC,
                        hintText: HINT_UPC,
                        isMask: false,
                        isNumber:false,
                        mask: false
                    ) : DropdownButton<String>(
                      isExpanded: true,
                      value: upcList![0],
                      style: const TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                      },
                      items: upcList
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
                  child:  defaultProductMode == 2 ? solidButton(BTN_ADD_UPC, EVENT_UPC_ADD)  : solidButton(BTN_UPDATE_UPC, EVENT_UPC_UPDATE)
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
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etCost,
                        labelText: TXT_COST,
                        hintText: HINT_COST,
                        isMask: false,
                        isNumber:true,
                        mask: false,
                        onChange: (text) {
                          textFieldOnChangeEvent(EVENT_COST, text);
                        },
                        validations: (value) {
                          if(!isValidateOn) {
                            return null;
                          } else if (etCost.text.isNotEmpty) {
                            return null;
                          } else {
                            return VALIDATE_COST;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                        read: readOnlyMode,
                        controller: etPrice,
                        labelText: TXT_PRICE,
                        hintText: HINT_PRICE,
                        isMask: false,
                        isNumber:true,
                        mask: false,
                        onChange: (text) {
                          textFieldOnChangeEvent(EVENT_PRICE, text);
                        } ,
                        validations: (value) {
                          if(!isValidateOn) {
                            return null;
                          } else if (etPrice.text.isNotEmpty) {
                            return null;
                          } else {
                            return VALIDATE_PRICE;
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
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child:  Custom_ListTile_TextField(
                          read: readOnlyMode,
                          controller: etMargin,
                          labelText: TXT_MARGIN,
                          hintText: HINT_MARGIN,
                          isMask: false,
                          isNumber:true,
                          mask: false,
                          onChange: (text) {
                            textFieldOnChangeEvent(EVENT_MARGIN, text);
                          } ,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child:  Custom_ListTile_TextField(
                          read: readOnlyMode,
                          controller: etMarkup,
                          labelText: TXT_MARKUP,
                          hintText: HINT_MARKUP,
                          isMask: false,
                          isNumber:true,
                          mask: false,
                          onChange: (text) {
                            textFieldOnChangeEvent(EVENT_MARKUP, text);
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
                        leading: const Text(TXT_DEPARTMENT),
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
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_DEPARTMENT));
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
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_CATEGORY));
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
                        leading: const Text(TXT_SECTION),
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
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_SECTION));
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
                        leading: const Text(TXT_VENDOR),
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
                            context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_VENDOR));
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
                    leading: const Text(TXT_DISCOUNT),
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
                        context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_DISCOUNT));
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
                    leading: const Text(TXT_TAX),
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
                        context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: newValue, dropDownType: EVENT_DROPDOWN_TAX));
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
                  const Expanded(
                      flex: 3,
                      child:  SizedBox()//defaultProductMode == 2 ? solidButton("Add To Batch", "ADD-SAVE-BATCH")  : solidButton("Save To Batch", "SAVE-BATCH")
                  ),
                  const Expanded(
                      flex: 3,
                      child:  SizedBox()//defaultProductMode == 2 ? solidButton("Add Batch", "ADD-BATCH") : solidButton("Update Batch", "UPDATE-BATCH")
                  ),
                  Expanded(
                      flex: 3,
                      child:  defaultProductMode == 2 ? solidButton(BTN_ADD_PRODUCT, EVENT_PRODUCT_ADD) : solidButton(BTN_UPDATE_PRODUCT, EVENT_PRODUCT_UPDATE)
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
                          labelText: TXT_CREATED_BY,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Custom_ListTile_TextField(
                          read: perReadOnly,
                          controller: etUpdatedBy,
                          labelText: TXT_UPDATED_BY,
                          isMask: false,
                          isNumber:false,
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
    if (event == EVENT_PRICE) {

    } else if (event == EVENT_COST) {

    } else if (event == EVENT_MARKUP) {
      calculateRevenueGivenMarkup();
    } else if (event == EVENT_MARGIN) {
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
        case BTN_UPDATE_ITEMCODE:
          return null;
        case BTN_UPDATE_UPC:
          return null;
        case BTN_UPDATE_PRODUCT:
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
    if(event ==  EVENT_SEARCH) {
      Map<String, String> map = <String, String>{
        "searchText" : "",
        "uid" : "",
        "itemCode" : "",
        "upc" : ""
      };
      if(searchOptionValue == 0) {
        String uid = eTSearchTopBy.text;
        map["uid"] = uid;
      } else if (searchOptionValue == 1) {
        String uid = eTSearchTopBy.text;
        map["itemCode"] = uid;
      } else if (searchOptionValue == 2) {
        String uid = eTSearchTopBy.text;
        map["upc"] = uid;
      } else if (searchOptionValue == 3) {
        String searchText = eTSearchTopBy.text;
        map["searchText"] = searchText;
      } else {
        throw new Exception("Invalid Dropdown Value Selected");
      }
      context.read<MainBloc>().add(MainParam.GetProductByParam(eventStatus: MainEvent.Event_GetProductByParamMap, userData: widget.userData, productParameter: map));
    } else if (event == EVENT_NEW_ITEM) {
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 2, dropDownType: EVENT_MODE_NEW_ITEM));
    } else if (event == EVENT_PRODUCT_UPDATE) {
      if(formKey.currentState!.validate()) {
        updateProductEvent();
      }
    } else if (event == EVENT_SEARCH_ITEM) {
      context.read<MainBloc>().add(MainParam.DropDown(eventStatus: MainEvent.Local_Event_DropDown_SearchBy, dropDownValue: 0, dropDownType: EVENT_MODE_SEARCH_ITEM));
    } else if (event == EVENT_PRODUCT_ADD) {

      if(formKey.currentState!.validate()) {
        addNewProductEvent();
      }
    } else if (event == EVENT_ITEMCODE_UPDATE) {
      context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_ItemCode_Update
          , userData: widget.userData, productData: mainProductModel, context: context));
    } else if (event == EVENT_ITEMCODE_ADD) {
      context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_ItemCode_Add
          , userData: widget.userData, productData: mainProductModel, context: context));
    } else if (event == EVENT_UPC_UPDATE) {
      ConsolePrint("UPC", "CLICK");
      context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Upc_Update
          , userData: widget.userData, productData: mainProductModel, context: context));
    } else if (event == EVENT_UPC_ADD) {
      context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Upc_Add
          , userData: widget.userData, productData: mainProductModel, context: context));
    }
  }

  /// UPDATE PRODUCT
  /// Item Code and Upc will be updated separately on it own panel
  void updateProductEvent() {
    ProductModel? model = mainProductModel;

    model?.description = eTDescription.text;
    model?.second_description = etDescription2.text;
    model?.third_description = etDescription3.text;
    model?.cost = double.parse(etCost.text);
    model?.price  = double.parse(etPrice.text);
    model?.updated_by = widget.userData?.uid;

    model?.departmentList = <String>[];
    model?.sectionList = <String>[];
    model?.categoryList = <String>[];
    model?.vendorList = <String>[];
    model?.discountList = <String>[];
    model?.taxList = <String>[];

    if(departmentDefault != STRING_NULL) {
      model?.departmentList.add(departmentDefault!);
      departmentDefaultValue = departmentList[departmentDefault];
    } else {
      departmentDefaultValue = EMPTY_VALUE;
    }

    if(sectionDefault != STRING_NULL) {
      model?.sectionList.add(sectionDefault!);
      sectionDefaultValue = sectionList[sectionDefault];
    } else {
      sectionDefaultValue = EMPTY_VALUE;
    }

    if(categoryDefault != STRING_NULL) {
      model?.categoryList.add(categoryDefault!);
      categoryDefaultValue = categoryList[categoryDefault];
    } else {
      categoryDefaultValue = EMPTY_VALUE;
    }

    if(vendorDefault != STRING_NULL) {
      model?.vendorList.add(vendorDefault!);
      vendorDefaultValue = vendorList[vendorDefault];
    } else {
      vendorDefaultValue = EMPTY_VALUE;
    }

    if(discountDefault != STRING_NULL) {
      model?.discountList.add(discountDefault!);
      discountDefaultValue = discountList[discountDefault];
    } else {
      discountDefaultValue = EMPTY_VALUE;
    }

    if(taxDefault != STRING_NULL) {
      model?.taxList.add(taxDefault!);
      taxDefaultValue = taxList[taxDefault];
    } else {
      taxDefaultValue = EMPTY_VALUE;
    }

    if(itemCodeDefault != STRING_NULL) {
      model?.itemCodeList = itemCodeList!;
      itemCodeDefaultValue = OK;
    } else {
      itemCodeDefaultValue = EMPTY_VALUE;
    }

    if(upcDefault != STRING_NULL) {
      model?.upcList = upcList!;
      upcDefaultValue = OK;
    } else {
      upcDefaultValue = EMPTY_VALUE;
    }

    Map<String, String> optionalParam = {
      'itemCodeDefaultValue' : itemCodeDefaultValue.toString(),
      'upcDefaultValue' : upcDefaultValue.toString(),
      'departmentDefault' : departmentDefaultValue.toString(),
      'sectionDefaultValue' : sectionDefaultValue.toString(),
      'categoryDefaultValue' : categoryDefaultValue.toString(),
      'vendorDefaultValue' : vendorDefaultValue.toString(),
      'discountDefaultValue' : discountDefaultValue.toString(),
      'taxDefaultValue' : taxDefaultValue.toString()
    };

    context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Update
        , productData: model, context: context, userData: widget.userData, optionalParameter: optionalParam));
  }

  /// ADD PRODUCT EVENT
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
      itemCodeDefaultValue = etItemCode.text;
    } else {
      itemCodeDefaultValue = EMPTY_VALUE;
    }

    if(etUpc.text.isNotEmpty) {
      model.upcList.add(etUpc.text);
      upcDefaultValue = etUpc.text;
    } else {
      upcDefaultValue = EMPTY_VALUE;
    }

    if(departmentDefault != STRING_NULL) {
      model.departmentList.add(departmentDefault!);
      departmentDefaultValue = departmentList[departmentDefault];
    } else {
     departmentDefaultValue = EMPTY_VALUE;
    }

    if(sectionDefault != STRING_NULL) {
      model.sectionList.add(sectionDefault!);
      sectionDefaultValue = sectionList[sectionDefault];
    } else {
      sectionDefaultValue = EMPTY_VALUE;
    }

    if(categoryDefault != STRING_NULL) {
      model.categoryList.add(categoryDefault!);
      categoryDefaultValue = categoryList[categoryDefault];
    } else {
      categoryDefaultValue = EMPTY_VALUE;
    }

    if(vendorDefault != STRING_NULL) {
      model.vendorList.add(vendorDefault!);
      vendorDefaultValue = vendorList[vendorDefault];
    } else {
      vendorDefaultValue = EMPTY_VALUE;
    }

    if(discountDefault != STRING_NULL) {
      model.discountList.add(discountDefault!);
      discountDefaultValue = discountList[discountDefault];
    } else {
      discountDefaultValue = EMPTY_VALUE;
    }

    if(taxDefault != STRING_NULL) {
      model.taxList.add(taxDefault!);
      taxDefaultValue = taxList[taxDefault];
    } else {
      taxDefaultValue = EMPTY_VALUE;
    }

    Map<String, String> optionalParam = {
      'itemCodeDefaultValue' : itemCodeDefaultValue.toString(),
      'upcDefaultValue' : upcDefaultValue.toString(),
      'departmentDefault' : departmentDefaultValue.toString(),
      'sectionDefaultValue' : sectionDefaultValue.toString(),
      'categoryDefaultValue' : categoryDefaultValue.toString(),
      'vendorDefaultValue' : vendorDefaultValue.toString(),
      'discountDefaultValue' : discountDefaultValue.toString(),
      'taxDefaultValue' : taxDefaultValue.toString()
    };
    context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Add
      , productData: model, context: context, userData: widget.userData, optionalParameter: optionalParam));

   // context.read<MainBloc>().add(MainParam.AddProduct(eventStatus: MainEvent.Event_AddProduct, productData: model, locationId: widget.userData?.defaultLocation?.uid));
  }

  Widget paginateTable() {
    DataTableSource _data = TableData(listProductPaginate, DataCount, context, widget.userData);
    return PaginatedDataTable2(
      columns: const [
        DataColumn(label: Text(TXT_PRODUCT_ID)),
        DataColumn(label: Text(TXT_DESCRIPTION)),
        DataColumn(label: Text(TXT_CREATE_DATETIME)),
        DataColumn(label: Text(TXT_UPDATED_DATETIME)),
      ],
      source: _data,
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
        map["searchText"] = "";
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