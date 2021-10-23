// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/View/Authentication/authentication.dart';
import 'package:npos/View/Component/Stateful/Menu/mainClientBody.dart';
import 'package:npos/View/Component/Stateful/Menu/mainMenuBody.dart';
import 'package:npos/View/Component/Stateful/Menu/mainProductManagementBody.dart';

class ProductManagement extends StatefulWidget {
  @override
  _ProductManagement createState() => _ProductManagement();
}

class _ProductManagement extends State<ProductManagement> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  bool isLoading = false;
  late Widget bodyContent;
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
                width: MediaQuery.of(context).size.width * 0.99,
                height: MediaQuery.of(context).size.height * 0.99,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    color: Colors.white),
                child: bodyContentEvent()// mainBodyComponent()
            )
        )
      ],
    );
  }

  Widget bodyContentEvent() {
    bodyContent = MainProductMannagementBody();
    //MainClientBody
    //MainMenuBody
    //MainProductMannagementBody
    return bodyContent;
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
      onPressed: () {},
      child: Text(text),
    );
  }

}
