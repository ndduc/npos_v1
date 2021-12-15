// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UiEvent/menuEvent.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/DeptCategory/deptCategoryManagement.dart';
import 'package:npos/View/ProductManagement/productManagement.dart';

import 'mainClientBody.dart';
import '../../../DeptCategory/Component/mainDepartmentCategory.dart';

class RoyalBody extends StatefulWidget {
  // Widget? bodyContent = MainMenuBody();
 // MainMenuBody();
 // MainMenuBody.withData(this.bodyContent);
  @override
  _RoyalBody createState() => _RoyalBody();
}

class _RoyalBody extends State<RoyalBody> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  Widget bodyContent = RoyalBody();
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
    return mainBodyComponent(context);
  }

  Widget mainBodyComponent(context) {
    return Column(
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
                            child:  UserCard()
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
                                  if(  UIItem.menuItemLeft[index]["event"] == "PC") {
                                    print("TEST");

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => ClientView()));
                                    setState(() {
                                     // this.bodyContent = MainClientBody();
                                    });
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
                    child: GridView.count(
                      childAspectRatio: 1.5,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4 ,
                      children:
                      List.generate(UIItem.menuItem.length, (index) {
                        return InkWell(
                          onTap: () {
                              String event = UIItem.menuItem[index]["event"];
                              switch(event){
                                case MENU_MAN_PROD:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_DEPTCATE:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => DeptCateManagement()));
                                  break;
                                case MENU_MAN_SEC:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_DISTAX:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_VEN:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_REPORT_INV:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_REPORT_DE:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_REPORT_DAI:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_REPORT_ANA:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_CUS_ROYAL:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_POINT:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_CUS_NOTI:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_SOC:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_EMP:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_MAN_LOC:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                case MENU_SETUP:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProductManagement()));
                                  break;
                                default:
                                  break;
                              }
                          },
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
                    ),
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

}