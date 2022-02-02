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
import 'package:npos/Constant/UI/TextStyles.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;
import 'package:npos/Constant/UIEvent/addProductEvent.dart';
import 'package:npos/Constant/Values/NumberValues.dart';
import 'package:npos/Constant/Values/StringValues.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/AddResponseModel.dart';
import 'package:npos/Model/ItemCodeModel.dart';
import 'package:npos/Model/ProductModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:provider/src/provider.dart';

class ProductDialogBlocAddUpdate extends StatefulWidget {
  String? whoAmI;
  ProductModel? productModel;
  UserModel? userModel;
  Map<String, String>? optionalParam;
  ProductDialogBlocAddUpdate({Key? key, required this.whoAmI, required this.productModel, required this.userModel, required this.optionalParam}) : super(key: key);
  @override
  Component createState() => Component();
}

class Component extends State<ProductDialogBlocAddUpdate> {
  late ProductModel productModel;
  late UserModel userModel;
  late Map<String, String> optionalParam;
  late AddResponseModel responseModel;
  uiImage uImage = uiImage();
  bool isLoading = false;
  bool readOnly = true;
  bool isProceeded = false;
  
  TextEditingController eTDescription = TextEditingController();
  TextEditingController etDescription2 = TextEditingController();
  TextEditingController etDescription3 = TextEditingController();
  TextEditingController etItemCode = TextEditingController();
  TextEditingController etUpc = TextEditingController();
  TextEditingController etCost =TextEditingController();
  TextEditingController etPrice = TextEditingController();
  TextEditingController etDepartment = TextEditingController();
  TextEditingController etSection = TextEditingController();
  TextEditingController etCategory = TextEditingController();
  TextEditingController etVendor = TextEditingController();
  TextEditingController etDiscount = TextEditingController();
  TextEditingController etTax = TextEditingController();

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel!;
    userModel = widget.userModel!;
    optionalParam = widget.optionalParam!;
    uiFunctionHandler();
  }

  void uiFunctionHandler() {
    if (widget.whoAmI == EVENT_PRODUCT_ADD) {
      setAddProductValue();
    } else {
      setUpdateProductValue();
    }

  }

  void setAddProductValue() {
    eTDescription.text = productModel.description.toString();
    etDescription2.text = productModel.second_description.toString().isEmpty ? EMPTY_VALUE : productModel.second_description.toString();
    etDescription3.text = productModel.third_description.toString().isEmpty ? EMPTY_VALUE : productModel.third_description.toString();
    etItemCode.text = optionalParam["itemCodeDefaultValue"].toString();
    etUpc.text = optionalParam["upcDefaultValue"].toString();
    etCost.text = productModel.cost.toString();
    etPrice.text = productModel.price.toString();
    etDepartment.text = optionalParam["departmentDefault"].toString();
    etSection.text = optionalParam["sectionDefaultValue"].toString();
    etCategory.text = optionalParam["categoryDefaultValue"].toString();
    etVendor.text = optionalParam["vendorDefaultValue"].toString();
    etDiscount.text = optionalParam["discountDefaultValue"].toString();
    etTax.text = optionalParam["taxDefaultValue"].toString();
  }

  void setUpdateProductValue() {
    eTDescription.text = productModel.description.toString();
    etDescription2.text = productModel.second_description.toString().isEmpty ? EMPTY_VALUE : productModel.second_description.toString();
    etDescription3.text = productModel.third_description.toString().isEmpty ? EMPTY_VALUE : productModel.third_description.toString();
    etCost.text = productModel.cost.toString();
    etPrice.text = productModel.price.toString();
    etDepartment.text = optionalParam["departmentDefault"].toString();
    etSection.text = optionalParam["sectionDefaultValue"].toString();
    etCategory.text = optionalParam["categoryDefaultValue"].toString();
    etVendor.text = optionalParam["vendorDefaultValue"].toString();
    etDiscount.text = optionalParam["discountDefaultValue"].toString();
    etTax.text = optionalParam["taxDefaultValue"].toString();
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
    if (state is DialogProductAddUpdateLoadedState) {
    }
  }

  void productEvent(MainState state) {
    if (state is ProductAddUpdateInitState) {
    } else if (state is ProductAddUpdateLoadingState) {
      isLoading = true;
    } else if (state is ProductAddUpdateLoadedState) {
      isLoading = false;
      isProceeded = true;
      responseModel = state.responseModel;

    } else if (state is ProductAddUpdateErrorState) {
      isLoading = false;
      context.read<MainBloc>().add(MainParam.showSnackBar(eventStatus: MainEvent.Show_SnackBar, context: context, snackBarContent: state.error.toString()));
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
            productEvent(state);
            /**
             * Bloc Action Note
             * END
             * */
            return buildContainer(context);
          }),
        ));
  }

  Widget buildContainer(context) {
    return isLoading ? ShareSpinner()  : mainBody();
  }

  Widget mainBody() {
    if(isProceeded) {
      return proceededBody();
    } else {
      return actionBody();
    }
    
  }

  Widget actionBody() {
    return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * UISize.dHeightQuery,
          bottom: MediaQuery.of(context).size.height * UISize.dHeightQuery,
          left: MediaQuery.of(context).size.width * UISize.dWidthQuerySm ,
          right: MediaQuery.of(context).size.width * UISize.dWidthQuerySm ,
        ),
        child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const Text(PRODUCT_CONFIRM_MESSAGE),
                    Text(widget.whoAmI == EVENT_PRODUCT_ADD ? PRODUCT_ADD_MESSAGE : PRODUCT_UPDATE_MESSAGE ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: eTDescription,
                          labelText: TXT_DESCRIPTION,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etDescription2,
                          labelText: TXT_DESCRIPTION_2,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etDescription3,
                          labelText: TXT_DESCRIPTION_3,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: null,
                          labelText: TXT_ITEMCODE,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    widget.whoAmI == EVENT_PRODUCT_UPDATE? const SizedBox() : Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etUpc,
                          labelText: TXT_UPC,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    widget.whoAmI == EVENT_PRODUCT_UPDATE? const SizedBox() : Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etItemCode,
                          labelText: TXT_ITEMCODE,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                  read: true,
                                  controller: etCost,
                                  labelText: TXT_COST,
                                  isMask: false,
                                  isNumber:true,
                                  mask: false,
                                )
                            ),
                            Expanded(
                                flex: 5,
                                child: Custom_ListTile_TextField(
                                  read: true,
                                  controller: etPrice,
                                  labelText: TXT_PRICE,
                                  isMask: false,
                                  isNumber:true,
                                  mask: false,
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etDepartment,
                          labelText: TXT_DEPARTMENT,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etSection,
                          labelText: TXT_SECTION,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etCategory,
                          labelText: TXT_CATEGORY,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etVendor,
                          labelText: TXT_VENDOR,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etDiscount,
                          labelText: TXT_DISCOUNT,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(GENERIC_TEXT_FIELD_MARGIN),
                      child: Custom_ListTile_TextField(
                          read: true,
                          controller: etTax,
                          labelText: TXT_TAX,
                          isMask: false,
                          isNumber:false,
                          mask: false
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: solidButton(BTN_YES, EVENT_YES),
                        ),
                        Expanded(
                            flex: 5,
                            child: solidButton(BTN_NO, EVENT_NO)
                        )
                      ],
                    )
                  ],
                )
            )
        ));
  }
  
  Widget proceededBody() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * UISize.dHeightQuery,
        bottom: MediaQuery.of(context).size.height * UISize.dHeightQuery,
        left: MediaQuery.of(context).size.width * UISize.dWidthQuerySm ,
        right: MediaQuery.of(context).size.width * UISize.dWidthQuerySm ,
      ),
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Column(
          children: [
            customText(RESPONSE_MODEL_PRODUCT  + WHITE_SPACE  + responseModel.Product_Location_Status.toString()),
            customText(RESPONSE_MODEL_DEPARTMENT  + WHITE_SPACE  + responseModel.Product_Department.toString()),
            customText(RESPONSE_MODEL_CATEGORY  + WHITE_SPACE  + responseModel.Product_Category.toString()),
            customText(RESPONSE_MODEL_VENDOR  + WHITE_SPACE  + responseModel.Product_Vendor.toString()),
            customText(RESPONSE_MODEL_SECTION  + WHITE_SPACE  + responseModel.Product_Section.toString()),
            customText(RESPONSE_MODEL_TAX  + WHITE_SPACE  + responseModel.Product_Tax.toString()),
            customText(RESPONSE_MODEL_DISCOUNT  + WHITE_SPACE  + responseModel.Product_Discount.toString()),
            customText(RESPONSE_MODEL_ITEMCODE  + WHITE_SPACE  + responseModel.Product_ItemCode.toString()),
            customText(RESPONSE_MODEL_UPC  + WHITE_SPACE  + responseModel.Product_Upc.toString()),
            solidButton(BTN_CONFIRM, EVENT_CONFIRM)
          ],
        ),
      )

      
    );
  }

  Widget customText(String text) {
    return Text(
      text,
      style: GENERIC_FONT
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
    if (widget.whoAmI == EVENT_PRODUCT_ADD) {
      if (event == EVENT_YES) {
        context.read<MainBloc>().add(MainParam.AddProduct(eventStatus: MainEvent.Event_AddProduct, productData: productModel, locationId: widget.userModel?.defaultLocation?.uid));
      } else if (event == EVENT_NO) {
        context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Add_No
            , productData: widget.productModel, context: context));
      } else if (event == EVENT_CONFIRM) {
        context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Add_Yes
            , productData: widget.productModel, context: context));
      }
    } else {
      if (event == EVENT_YES) {
        context.read<MainBloc>().add(MainParam.UpdateProduct(eventStatus: MainEvent.Event_UpdateProduct, productData: productModel, locationId: widget.userModel?.defaultLocation?.uid));
      } else if (event == EVENT_NO) {
        context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Update_No
            , productData: widget.productModel, context: context));
      } else if (event == EVENT_CONFIRM) {
        context.read<MainBloc>().add(MainParam.NavDialog(eventStatus: MainEvent.Nav_Dialog_Product_Add_Yes
            , productData: widget.productModel, context: context));
      }
    }

  }



  Widget txtButton(text) {
    return TextButton(
      onPressed: () {},
      child: Text(text),
    );
  }


}
