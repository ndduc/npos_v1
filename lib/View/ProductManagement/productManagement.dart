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
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Model/UserModel.dart';
import 'Component/mainProductManagementBody.dart';

class ProductManagement extends StatefulWidget {
  UserModel? userData;
  ProductManagement({Key? key, this.userData}) : super(key: key);
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
        body:
        BlocBuilder<MainBloc,MainState>(builder: (BuildContext context,MainState state) {
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
        })

        ),
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
    bodyContent = MainProductManagementBody(userData: widget.userData);
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
