// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc/MainBloc/MainBloc.dart';
import 'Bloc/Theme/ThemeBloc.dart';
import 'Repository/MainRepos.dart';
import 'View/Authentication/authentication.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
      const BlocRun()
  );
}

class BlocRun  extends StatefulWidget{
  const BlocRun({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BlocState();
  }

}

class BlocState extends State<BlocRun>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ThemeBloc(),
      child: BlocBuilder<ThemeBloc,ThemeState>(
        builder: (BuildContext context,ThemeState themeState){
          return   MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            theme: themeState.themeData,
            home: BlocProvider(create: (context)=>MainBloc(mainRepo: MainRepository()),
                child:Authentication()),

          );
        },
      ),
    );
  }

}

/// scroll support for other platform beside android and ios
/// this should override the entire app
/// https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authentication(),
    );
  }
}

*/