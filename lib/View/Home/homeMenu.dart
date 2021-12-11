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
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Debug/Debug.dart';
import 'package:npos/Model/UserModel.dart';
import 'Component/mainMenuBody.dart';
import 'Component/menuEvent.dart';

class HomeMenu extends StatefulWidget {
  UserModel? userData;
  HomeMenu({Key? key, this.userData}) : super(key: key);
  @override
  _HomeMenu createState() => _HomeMenu();
}

class _HomeMenu extends State<HomeMenu> {
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
        body: BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
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
    ));
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
    bodyContent = MainMenuBody(userData: widget.userData!, gridViewItem: gridViewItem());
    return bodyContent;
  }

  Widget gridViewItem() {
    return GridView.count(
      childAspectRatio: 1.5,
      scrollDirection: Axis.vertical,
      crossAxisCount: 4 ,
      children:
      List.generate(UIItem.menuItem.length, (index) {
        return InkWell(
          onTap: menuClickEvent(index, context, widget.userData!),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: Colors.blueAccent),
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: Center(
                  child: Text(
                    UIItem.menuItem[index]['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )
          ),
        ) ;
      }),
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
      onPressed: () {},
      child: Text(text),
    );
  }

}
