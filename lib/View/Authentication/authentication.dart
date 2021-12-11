// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:npos/Bloc/MainBloc/MainBloc.dart';
import 'package:npos/Bloc/MainBloc/MainEvent.dart';
import 'package:npos/Bloc/MainBloc/MainState.dart';

import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:npos/View/Component/Stateful/customDialog.dart';
import 'package:npos/View/Home/homeMenu.dart';
import 'package:provider/src/provider.dart';

class Authentication extends StatefulWidget {
  @override
  _Authentication createState() => _Authentication();
}

class _Authentication extends State<Authentication> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  bool isLoading = false;
  bool isAuthorized = false;
  TextEditingController conUsername = TextEditingController();
  TextEditingController conPassword = TextEditingController();
  UserModel? userData;
  @override
  void initState() {
    super.initState();
    loadAlbums();
  }

  loadAlbums() async
  {
    //context.read<MainBloc>().add(MainEvent.fetchAlbums);
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
    } else if (state is GenericErrorState) {
      isLoading = false;
      context.read<MainBloc>().add(MainParam.showSnackBar(eventStatus: MainEvent.Show_SnackBar, context: context, snackBarContent: state.error.toString()));
    }
  }

  void appSpecificEvent(MainState state) {
    // Executing Specific State
    if(state is StateLoadedOnAuthorizingUser) {
      isLoading = false;
      userData = state.userModel as UserModel;
      context.read<MainBloc>().add(MainParam.GetAuthorization(eventStatus: MainEvent.Check_Authorization, userData: userData));
    } else if (state is CheckAuthorizeStateLoaded) {
      userData = state.userModel as UserModel;
      context.read<MainBloc>().add(MainParam.GenericNavigator(eventStatus: MainEvent.Nav_MainMenu, userData: userData, context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(
      onWillPop: () async => false,
      child:
      Scaffold(
        body: BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state){
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
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(uImage.mapImage['bg-3']),
                  fit: BoxFit.cover,
                ),
              ),
              child: mainBody());
        }),
      ),
    );
  }

  Widget mainBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Container(
                width: MediaQuery.of(context).size.height * UISize.widthQuery,
                height: MediaQuery.of(context).size.height * UISize.widthQuery,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    color: Colors.white),
                child: this.isLoading ? ShareSpinner() :

                Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loginLogo(),
                        Text(uIText.homeTxtIntro),
                        inputTextField(uIText.homeTxtUserName, conUsername, false),
                        inputTextField(uIText.homeTxtPassword, conPassword, true),
                        solidButton(uIText.homeBtnLogin),
                        txtButton(uIText.homeTxtForget),
                        txtButton(uIText.homeTxtRegistration)
                      ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(top: 3, bottom: 3),
                              child: e,
                            ),
                          )
                          .toList(),
                    )
                )
            )
        )
      ],
    );
  }

  Widget loginLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Expanded(
            flex: 1,
            child: Icon(
              Icons.audiotrack,
              color: Colors.green,
            )),
        Expanded(flex: 5, child: Text("Welcome")),
      ],
    );
  }

  Widget inputTextField(type, controller, bool isObscure) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: type,
      ),
      controller: controller,
    );
  }

  Widget solidButton(text) {
    return ElevatedButton(
      // style: style,
      onPressed: () {
        context.read<MainBloc>().add(MainParam.VerifyUser(eventStatus: MainEvent.Event_VerifyUser, userName: conUsername.text, password: conPassword.text));
      },
      child: Text(text),
    );
  }

  Widget txtButton(text) {
    return TextButton(
      // style: style,
      onPressed: () {
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 500),
          context: context,
          pageBuilder: (_, __, ___) {
            return CustomDialog();
          },
          transitionBuilder: (_, anim, __, child) {
            return SlideTransition(
              position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
              child: child,
            );
          },
        );
      },
      child: Text(text),
    );
  }
}
