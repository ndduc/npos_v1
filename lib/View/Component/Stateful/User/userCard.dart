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
import 'package:npos/Model/UserModel.dart';
import 'package:npos/Share/Component/Spinner/ShareSpinner.dart';
import 'package:provider/src/provider.dart';

class UserCard extends StatefulWidget {
  UserModel? userData;
  UserCard({Key? key, this.userData}) : super(key: key);
  @override
  _UserCard createState() => _UserCard();
}

class _UserCard extends State<UserCard> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  bool isLoading = false;

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
    } else if (state is GenericLoadedState) {
      isLoading = false;
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
      return UserCard(context);
    });


  }

  // ignore: non_constant_identifier_names
  Widget UserCard(context) {
    if(isLoading) {
      return  ShareSpinner();
    } else {
      String locationName = widget.userData!.defaultLocation!.name ?? "Not Found";
      return Card(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child:  Image.asset(
                  uImage.mapImage['bg-1'],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userData!.uid),
                    Text("User Name: " + widget.userData!.firstName + " " + widget.userData!.lastName),
                    Text("User Role: " + widget.userData!.userType!),
                    Text("Location: " + locationName),
                  ],
                ),
              )

            ],
          )
      );
    }
  }

}