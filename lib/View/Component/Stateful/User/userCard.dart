// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';

class UserCard extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return UserCard(context);
  }

  Widget UserCard(context) {
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
                children: const [
                  Text("User Id: 69696969"),
                  Text("User Name: Duc Nguyen"),
                  Text("User Role: Admin"),
                  Text("Date: 09-18-2021 - 11:54 PM"),
                ],
              ),
            )

          ],
        )
    );
  }

}