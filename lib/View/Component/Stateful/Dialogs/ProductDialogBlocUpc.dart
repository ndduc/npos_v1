// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/API/MapValues.dart' as MapValue;
import 'package:npos/Constant/API/MapValues.dart';
import 'package:npos/Constant/UI/Product/ProductShareUIValues.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;
import 'package:npos/Constant/UIEvent/AddUpdateUpcItemCodeEvent.dart';
import 'package:npos/Constant/Values/NumberValues.dart';
import 'package:npos/Constant/Values/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/ApiModel/ItemCodePaginationModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:provider/src/provider.dart';

class ProductDialogBlocUpc extends StatefulWidget {
  UserModel? userModel;
  ProductModel? productMode;
  String? whoAmI;
  ProductDialogBlocUpc({Key? key, required this.userModel, required this.productMode, required this.whoAmI}) : super(key: key);
  @override
  Component createState() => Component();
}

class Component extends State<ProductDialogBlocUpc> {
  var formKey = GlobalKey<FormState>();
  bool isModifying = false;
  bool isValidateOn = true;
  bool isItemCodeExist = false;
  bool allowSave = true;
  bool allowDelete = true;
  bool addNewItemCode = false;
  uiImage uImage = uiImage();
  bool isLoading = false;
  bool isComponentLoading = false;
  bool readOnly = true;
  bool readOnlyItemCode = true;
  TextEditingController etItemCode = TextEditingController();
  TextEditingController etDescription = TextEditingController();
  TextEditingController etPrice = TextEditingController();
  TextEditingController etCost = TextEditingController();
  TextEditingController etMargin = TextEditingController();
  TextEditingController etMarkup = TextEditingController();
  TextEditingController etExtDesc = TextEditingController();
  TextEditingController etNote = TextEditingController();
  late ProductModel model;
  late ItemCodeModel itemCodeModel;
  ItemCodePaginationModel itemCodePaginateModel = ItemCodePaginationModel.empty();
  @override
  void initState() {
    super.initState();
    ConsolePrint("Who Am I", widget.whoAmI);
    if (widget.whoAmI == EVENT_ADD_UPC) {
      model = ProductModel();
      addNewItemCode = true;
    } else if (widget.whoAmI == EVENT_UPDATE_UPC) {

      model = widget.productMode!;
      addNewItemCode = false;
    }
    initialLoad();
    uiFunctionHandler();
  }

  void initialLoad() {
    Map<String, String> param = {
      "limit" : "100",
      "offset" : "0",
      "order" : "ASC",
      "selectedItemCode" : model.itemCode.toString() //only add this on the initial load
    };
    context.read<MainBloc>().add(MainParam.GetItemCodePagination(eventStatus: MainEvent.Event_GetItemCodePagination
        , userData: widget.userModel, productData: widget.productMode, optionalParameter: param));
  }

  void uiFunctionHandler() {
    if (addNewItemCode) {

    } else {
      setValue();
    }
  }

  void setValue() {
    readOnlyItemCode = true;
    ConsolePrint("SetValue", "Called");
    if (model.itemCode == NUMBER_NULL) {
      etItemCode.text = HINT_ITEMCODE_ADD_UPDATE;
    } else {
      etItemCode.text = model.itemCode.toString();
    }
    etDescription.text = model.description!;
    etPrice.text = model.price.toString();
    etCost.text = model.cost.toString();
    etExtDesc.text = model.second_description ?? EMPTY;
    etNote.text = model.third_description ?? EMPTY;
    etMarkup.text = marginCalculation(double.parse(etPrice.text), double.parse(etCost.text)).toString();
    etMargin.text = marginCalculation(double.parse(etPrice.text), double.parse(etCost.text)).toString();
  }

  // Call this when dialog was init as update
  void setValueAddItemCode() {
    etItemCode.text = "";
    readOnlyItemCode = false;
  }

  double marginCalculation(double price, double cost) {
    double? margin =  (price - cost) / price;
    return margin;
  }

  double markupCalculation(double price, double cost) {
    double? markup = (price - cost) / cost;
    return markup;
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

  void getItemCodeEvent(MainState state) {

    /// Item Code Get
    //region Get Item Code Pagination
    if (state is ItemCodeGetInitState) {

    } else if (state is ItemCodeGetLoadingState) {

    } else if (state is ItemCodeGetLoadedState) {
      itemCodePaginateModel = state.response;
      if (state.selectedItemCode != null) {
        for(int i = 0; i < itemCodePaginateModel.itemCodeList.length; i++) {
          if (itemCodePaginateModel.itemCodeList[i].itemCode == state.selectedItemCode.toString()) {
            itemCodeModel = itemCodePaginateModel.itemCodeList[i];
            break;
          }
        }
      }
    }
    //endregion
    /// Item Code Table Click
    //region Item Code Table Click
    else if (state is ItemCodeTableClickInitState) {

    } else if (state is ItemCodeTableClickLoadingState) {

    } else if (state is ItemCodeTableClickLoadedState) {
      itemCodeModel = state.response;
      model.itemCode = int.parse(state.response.itemCode.toString());
      allowSave = true;
      allowDelete = true;
      setValue();
    }
    //endregion
    /// New Item Code Click
    //region New Item Code
    else if (state is NewItemCodeClickInitState) {

    } else if (state is NewItemCodeClickLoadingState) {

    } else if (state is NewItemCodeClickLoadedState) {
      if (state.response[EVENT_NEW_ITEMCODE_MODE]) {
        setValueAddItemCode();
        allowSave = false;
        allowDelete = false;
      }
    }
    //endregion
    /// Verify Item Code
    //region Verify Item Code
    else if (state is ItemCodeVerifyInitState) {

    } else if (state is ItemCodeVerifyLoadingState) {
      isComponentLoading = true;
    } else if (state is ItemCodeVerifyLoadedState) {
      if (state.response) {
        //Item Code Exist
        isItemCodeExist = true;
        allowSave = false;
      } else {
        //Item Code Not Exist
        isItemCodeExist = false;
        allowSave = true;
      }
      isComponentLoading = false;
    }
    //endregion
  }

  void modifyItemCodeEvent(MainState state) {
    if (state is ItemCodeAddInitState) {

    } else if (state is ItemCodeAddLoadingState) {

    } else if (state is ItemCodeAddLoadedState) {
      initialLoad();
    } else if (state is ItemCodeDeleteInitState) {

    } else if (state is ItemCodeDeleteLoadingState) {

    } else if (state is ItemCodeDeleteLoadedState) {
      initialLoad();
    }
  }

  void itemCodeErrorState(MainState state) {
    if (state is ItemCodeErrorState) {
      isComponentLoading = false;
      isLoading = false;
      //Trigger some sort of snack bar to notify user about the error here
    }
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
            getItemCodeEvent(state);
            itemCodeErrorState(state);
            modifyItemCodeEvent(state);
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
          padding: const EdgeInsets.all(GENERIC_CONTAINER_PADDING),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(GENERIC_BORDER_RADIUS)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Form(
              key: formKey,
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
                                  autoValidate: AutovalidateMode.onUserInteraction,
                                  controller: etItemCode,
                                  read: readOnlyItemCode,
                                  labelText: TXT_ITEMCODE,
                                  isMask: false,
                                  isNumber:false,
                                  mask: false,
                                  validations: (value) {
                                    if (isItemCodeExist) {
                                      return VALIDATE_ITEMCODE;
                                    } else {
                                      return null;
                                    }

                                  },
                                  onChange: (value) {
                                    ConsolePrint("On Changed", value);
                                  },
                                  onEdit: () {
                                    ConsolePrint("On Edit", "");
                                  },
                                  onSubmit: (value) {
                                    ConsolePrint("On Submit", value);
                                  },
                                  onFocusChange: (value) {
                                    if (!value) {
                                      ConsolePrint("On onFocusChange", value);
                                      ConsolePrint("VALUE", etItemCode.text);
                                      context.read<MainBloc>().add(MainParam.ItemCodeVerify(eventStatus: MainEvent.Event_ItemCodeVerify,
                                          itemCodeParameter: {
                                            MapValue.USER_ID: widget.userModel?.uid.toString(),
                                            MapValue.LOCATION_ID: widget.userModel?.defaultLocation?.uid.toString(),
                                            MapValue.PRODUCT_ID: widget.productMode?.uid.toString(),
                                            MapValue.ITEM_CODE: etItemCode.text
                                          }
                                      )
                                      );
                                    }

                                  },


                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: isComponentLoading ? ShareSpinner() :  solidButton(BTN_NEW_ITEMCODE, EVENT_NEW_ITEMCODE_MODE)
                              )
                            ],
                          ),

                          Custom_ListTile_TextField(
                              controller: etDescription,
                              read: readOnly,
                              labelText: TXT_DESCRIPTION,
                              isMask: false,
                              isNumber:false,
                              mask: false
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    controller: etPrice,
                                    read: readOnly,
                                    labelText:TXT_PRICE,
                                    isMask: false,
                                    isNumber:false,
                                    mask: false
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    controller: etCost,
                                    read: readOnly,
                                    labelText: TXT_COST,
                                    isMask: false,
                                    isNumber:false,
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
                                    controller: etMargin,
                                    read: readOnly,
                                    labelText: TXT_MARGIN,
                                    isMask: false,
                                    isNumber:false,
                                    mask: false
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                    controller: etMarkup,
                                    read: readOnly,
                                    labelText: TXT_MARKUP,
                                    isMask: false,
                                    isNumber:false,
                                    mask: false
                                ),
                              )
                            ],
                          ),
                          Custom_ListTile_TextField(
                            controller: etExtDesc,
                            read: readOnly,
                            labelText: TXT_DESCRIPTION_2,
                            isMask: false,
                            isNumber:false,
                            mask: false,
                            maxLines: 5,
                          ),
                          Custom_ListTile_TextField(
                            controller: etNote,
                            read: readOnly,
                            labelText: TXT_DESCRIPTION_3,
                            isMask: false,
                            isNumber:false,
                            mask: false,
                            maxLines: 5,
                          ),
                          Row(
                            children: [
                              const Expanded(
                                  flex: 4,
                                  child: SizedBox()
                              ),
                              Expanded(
                                  flex: 2,
                                  child: solidButton(BTN_DISMISS, EVENT_CLOSE)
                              ),
                              Expanded(
                                  flex: 2,
                                  child: allowDelete? solidButton(BTN_DELETE, EVENT_DELETE_ITEMCODE) : solidButton(BTN_DELETE, EMPTY)
                              ),
                              Expanded(
                                  flex: 2,
                                  child: allowSave? solidButton(BTN_SAVE, EVENT_SAVE_ITEMCODE) : solidButton(BTN_SAVE, EMPTY)
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
            )


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
    if (event.isEmpty) {
      return null;
    } else {
      return () {
        solidButtonEvent(event);
      };
    }
  }

  void solidButtonEvent(String event) {
    if(event == EVENT_CLOSE) {
      Navigator.pop(context);
    } else if (event == EVENT_NEW_ITEMCODE_MODE) {
      context.read<MainBloc>().add(MainParam.NewItemCodeClick(eventStatus: MainEvent.Event_NewItemCodeClick, itemCodeParameter: {EVENT_NEW_ITEMCODE_MODE: true}));
    } else if (event == EVENT_SAVE_ITEMCODE) {
      addItemCode();
    } else if (event == EVENT_DELETE_ITEMCODE) {
      deleteItemCode();
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
    DataTableSource _data = TableData(itemCodePaginateModel.itemCodeList, itemCodePaginateModel.itemCodeList.length, context);
    return PaginatedDataTable2(
      columns: const [
        DataColumn(label: Text(TXT_ITEMCODE)),
        DataColumn(label: Text(TXT_CREATE_DATETIME)),
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

  void addItemCode() {
    ConsolePrint("Event", "Save Item Code");
    context.read<MainBloc>().add(MainParam.AddItemCode(eventStatus: MainEvent.Event_ItemCodeAdd,
        itemCodeParameter: {
          MapValue.USER_ID: widget.userModel?.uid.toString(),
          MapValue.LOCATION_ID: widget.userModel?.defaultLocation?.uid.toString(),
          MapValue.PRODUCT_ID: widget.productMode?.uid.toString(),
          MapValue.ITEM_CODE: etItemCode.text
        }
      )
    );
  }

  void deleteItemCode() {
    ConsolePrint("Delete", "ItemCode");
    context.read<MainBloc>().add(MainParam.DeleteItemCode(eventStatus: MainEvent.Event_ItemCodeDelete,
        itemCodeParameter: {
          MapValue.USER_ID: widget.userModel?.uid.toString(),
          MapValue.LOCATION_ID: widget.userModel?.defaultLocation?.uid.toString(),
          MapValue.PRODUCT_ID: widget.productMode?.uid.toString(),
          MapValue.ITEM_CODE: etItemCode.text
        }
      )
    );
  }
}

class TableData extends DataTableSource {
  BuildContext context;
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
          context.read<MainBloc>().add(
              MainParam.ItemCodeTableLick(
                  eventStatus: MainEvent.Event_ItemCodeTableClick,
                  itemCodeData: selectedModel,
                  ));
        },
        cells: [
          DataCell(Text(lstModel[index].itemCode.toString())),
          DataCell(Text(lstModel[index].added_datetime.toString()))
        ]
    );
  }
}
