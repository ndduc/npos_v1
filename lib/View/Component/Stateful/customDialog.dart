// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiSize.dart' as UISize;

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialog createState() => _CustomDialog();
}

class _CustomDialog extends State<CustomDialog> {
  uiImage uImage = uiImage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * UISize.dHeightQuery,
            bottom: MediaQuery.of(context).size.height * UISize.dHeightQuery,
            left: MediaQuery.of(context).size.width * UISize.dWidthQuery,
            right: MediaQuery.of(context).size.width * UISize.dWidthQuery),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage(uImage.mapImage['p-1-port']),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Text("TEST"),
                    )),
                Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(child: mainBody())))
              ],
            )));
  }

  Widget mainBody() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * UISize.dWidthQuery),
        child: Column(
          children: [
            Text("Possibly, put contact information here"),
            txtButton("Something Here"),
            solidButton("TEST")
          ],
        ));
  }

  Widget solidButton(text) {
    return ElevatedButton(
      // style: style,
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(text),
    );
  }

  Widget txtButton(text) {
    return TextButton(
      // style: style,
      onPressed: () {},
      child: Text(text),
    );
  }
}
