// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/Home/homeMenu.dart';

import '../customDialog.dart';

class MainClientBody extends StatefulWidget {
  @override
  _MainClientBody createState() => _MainClientBody();
}

class _MainClientBody extends State<MainClientBody> {
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
    return mainBody();
  }

  Widget mainBody() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: bodyCheckOut(),
        ),
        Expanded(
          flex: 4,
          child: bodyInput(),
        ),
        Expanded(
          flex: 2,
          child: bodyOption(),
        )
      ],
    );
  }

  Widget bodyCheckOut() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: // Text("TEST 4-1"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: "User Input, This will be always focus",
                hintText: "Hint",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),

          )

        ),
        Expanded(
          flex: 8,
          child: //Text("TEST 4-8"),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
          )
        ),
        Expanded(
          flex: 1,
          child:Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
          ),
        )
      ]
    );
  }

  Widget bodyInput() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: optionItemTop(),
          )
        )  ,
        Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.blueAccent),
              ),
            )
        )
      ],
    );
  }

  Widget bodyOption() {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: UserCard(),
            )
        )  ,
        Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: optionItem(),
            )
        )
      ],
    );
  }


  Widget optionItem() {
    return SingleChildScrollView(
        child:  SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            childAspectRatio: 3,
            scrollDirection: Axis.vertical,
            crossAxisCount: 1 ,
            children:
            List.generate(UIItem.clientOption.length, (index) {
              return Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  child: Center(
                      child: Text(
                        UIItem.clientOption[index]['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
              );
            }),
          ),
        )
    );
  }

  final ScrollController _scroll = ScrollController();
  Widget optionItemTop() {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scroll,
      child: ListView.builder(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          itemCount: UIItem.clientOptionTop.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                String event = UIItem.clientOptionTop[index]["event"];
                switch(event) {
                  case "RT":
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => HomeMenu()));
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
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(
                      child: Text(
                        UIItem.clientOptionTop[index]["name"],
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
    );
  }

}