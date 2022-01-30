// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UIEvent/menuEvent.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/GenericComponents/listTileTextField.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/Home/homeMenu.dart';



import '../../Client/Component/mainClientBody.dart';
import 'Discount.dart';
import 'Tax.dart';


class DisTaxBody extends StatefulWidget {
  UserModel? userData;
  DisTaxBody({Key? key, this.userData}) : super(key: key);
  @override
  Component createState() => Component();
}

class Component extends State<DisTaxBody> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  bool isLoading = false;
  String currentScreen = "DISCOUNT";
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
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

  void appSpecificEvent(MainState state) {
    // Executing Specific State
    if (state is SwitchScreenLoadedState) {
      if (state.toWhere == "DISCOUNT") {
        currentScreen = state.toWhere;
      } else if (state.toWhere == "TAX") {
        currentScreen = state.toWhere;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
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
                            child:  UserCard(userData: widget.userData)
                        ),
                      ),
                      Expanded(
                        flex: 1,
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
                                      height: MediaQuery.of(context).size.height * 0.10,
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
                      Expanded(
                        flex: 5,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: UIItem.discountTaxOptionList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    String event = UIItem.discountTaxOptionList[index]["event"];   // POS Menu
                                    switch(event) {
                                      case OPTION_DISCOUNT:
                                      // Switch Main Container On Click
                                      // Clear Data State of the current screen
                                        print("DISC OPT");
                                        context.read<MainBloc>().add(MainParam.SwitchScreen(eventStatus: MainEvent.Local_Event_Switch_Screen, toWhere: "DISCOUNT", userData: widget.userData));
                                        break;
                                    // Switch Main Container On Click
                                    // Clear Data State of the current screen
                                      case OPTION_TAX:
                                        print("TAX OPT");
                                        context.read<MainBloc>().add(MainParam.SwitchScreen(eventStatus: MainEvent.Local_Event_Switch_Screen, toWhere: "TAX", userData: widget.userData));
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
                                      height: MediaQuery.of(context).size.height * 0.10,
                                      child: Center(
                                          child: Text(
                                            UIItem.discountTaxOptionList[index]["name"],
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
              mainItem()
            ],
          ),
        )
      ],
    );
  }


  Widget mainItem() {
    if (currentScreen == "DISCOUNT") {
      return Discount(userData: widget.userData);
    } else {
      return Tax(userData: widget.userData);
    }

  }



}
