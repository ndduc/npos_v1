// ignore_for_file: file_names
// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'package:npos/Constant/UI/uiImages.dart';
import 'package:npos/Constant/UI/uiItemList.dart' as UIItem;
import 'package:npos/Constant/UI/uiText.dart';
import 'package:npos/Constant/UiEvent/menuEvent.dart';
import 'package:npos/View/Client/clientView.dart';
import 'package:npos/View/Component/Stateful/User/userCard.dart';
import 'package:npos/View/DailyReport/dailyReport.dart';
import 'package:npos/View/DeptCategory/deptCategoryManagement.dart';
import 'package:npos/View/DetailReport/detailReport.dart';
import 'package:npos/View/DiscTaxManagement/disTaxManagement.dart';
import 'package:npos/View/EmployeeManagement/employeeManagement.dart';
import 'package:npos/View/InventoryReport/inventoryReport.dart';
import 'package:npos/View/LocationManagement/locationManagement.dart';
import 'package:npos/View/NotifyManagement/notifyManagement.dart';
import 'package:npos/View/PerformReport/performReport.dart';
import 'package:npos/View/PointManagement/pointManagement.dart';
import 'package:npos/View/ProductManagement/productManagement.dart';
import 'package:npos/View/RoyalManagement/royalManagement.dart';
import 'package:npos/View/SectionManagement/sectionManagement.dart';
import 'package:npos/View/SocialManagement/socialManagement.dart';
import 'package:npos/View/SystemManagement/systemManagement.dart';
import 'package:npos/View/VenSupManagement/venSupManagement.dart';

import 'mainClientBody.dart';
import 'mainDepartmentCategory.dart';

class MainMenuBody extends StatefulWidget {
  // Widget? bodyContent = MainMenuBody();
 // MainMenuBody();
 // MainMenuBody.withData(this.bodyContent);
  @override
  _MainMenuBody createState() => _MainMenuBody();
}

class _MainMenuBody extends State<MainMenuBody> {
  uiText uIText = uiText();
  uiImage uImage = uiImage();
  Widget bodyContent = MainMenuBody();
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
                                      .push(MaterialPageRoute(builder: (context) => SectionManagement()));
                                  break;
                                case MENU_MAN_DISTAX:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => DisTaxManagement()));
                                  break;
                                case MENU_MAN_VEN:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => VendorManagement()));
                                  break;
                                case MENU_REPORT_INV:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => InventoryReport()));
                                  break;
                                case MENU_REPORT_DE:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => DetailReport()));
                                  break;
                                case MENU_REPORT_DAI:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => DailyReport()));
                                  break;
                                case MENU_REPORT_ANA:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => PerformReport()));
                                  break;
                                case MENU_MAN_CUS_ROYAL:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => RoyalManagement()));
                                  break;
                                case MENU_MAN_POINT:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => PointManagement()));
                                  break;
                                case MENU_MAN_CUS_NOTI:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => NotifyManagement()));
                                  break;
                                case MENU_MAN_SOC:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => SocialManagement()));
                                  break;
                                case MENU_MAN_EMP:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => EmployeeManagement()));
                                  break;
                                case MENU_MAN_LOC:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => LocationManagement()));
                                  break;
                                case MENU_SETUP:
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => SystemManagement()));
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