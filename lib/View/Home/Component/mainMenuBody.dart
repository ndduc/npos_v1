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
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/LocationModel.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';

class MainMenuBody extends StatefulWidget {
  late UserModel userData;
  late Widget gridViewItem;
  MainMenuBody({Key? key, required this.userData, required this.gridViewItem}) : super(key: key);
  @override
  _MainMenuBody createState() => _MainMenuBody();
}

class _MainMenuBody extends State<MainMenuBody> {
  bool isLoading = false;
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  @override
  void initState() {
    super.initState();

    LocationModel locationModelTmp = widget.userData.locationList![0];
    if(locationModelTmp.isError) {
      // Error Mean, the user does not have any specific location. If this is a case then prevent user from moving further
    } else {
      if( widget.userData.locationList!.length > 1) {
        // LocationList > 1, meaning the user have multiple location
        // Setup a dialog, and allow user to choose location for this session.
      } else {
        context.read<MainBloc>().add(MainParam.SetDefaultLocation(eventStatus: MainEvent.Local_Event_Set_DefaultLocation, userData: widget.userData, index: 0));
      }

    }

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
      isLoading = true;
    } else if (state is GenericLoadedState) {
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
    //return  mainBodyComponent(context);
    return BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
      appBaseEvent(state);
      appSpecificEvent(state);
      return mainBodyComponent(context);
    });
  }
  Widget mainBodyComponent(context) {
    return isLoading? ShareSpinner() : Column(
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
                            itemCount: UIItem.menuItemLeft.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  /// POS Client
                                  if(  UIItem.menuItemLeft[index]["event"] == "PC") {
                                    if(  UIItem.menuItemLeft[index]["event"] == "PC") {
                                      context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_POS_Client, context: context, userData: widget.userData));
                                    }
                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(builder: (context) => ClientView()));
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
                                          UIItem.menuItemLeft[index]["name"],
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
              SingleChildScrollView(
                  child:  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    height: MediaQuery.of(context).size.height * 0.98,
                    child: widget.gridViewItem
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

}