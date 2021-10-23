// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npos/Bloc/UserBloc.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/View/Component/Stateful/customDialog.dart';
import 'package:npos/View/Home/homeMenu.dart';

class Authentication extends StatefulWidget {
  @override
  _Authentication createState() => _Authentication();
}

class _Authentication extends State<Authentication> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  bool isLoading = false;
  TextEditingController conUsername = TextEditingController();
  TextEditingController conPassword = TextEditingController();
  TextEditingController conLocation = TextEditingController();

  @override
  void initState() {
    super.initState();

    UserBLoC userBLoC = new UserBLoC();
    userBLoC.usersList;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     image: DecorationImage(image: AssetImage(uImage.mapImage['bg-3']), fit: BoxFit.cover),
    //   ),
    //   child: WillPopScope(
    //     onWillPop: () async => false,
    //     child: Scaffold(body: mainBody()))
    // );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(uImage.mapImage['bg-3']),
                  fit: BoxFit.cover,
                ),
              ),
              child: mainBody())),
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
                child: Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loginLogo(),
                        Text(uIText.homeTxtIntro),
                        inputTextField(uIText.homeTxtLocaionId, conLocation),
                        inputTextField(uIText.homeTxtUserName, conUsername),
                        inputTextField(uIText.homeTxtPassword, conPassword),
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
                    ))))
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

  Widget inputTextField(type, controller) {
    return TextField(
      obscureText: true,
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeMenu()));
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
