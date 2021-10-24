import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Block/users_block.dart';
import 'Bloc/Theme/theme_block.dart';
import 'Repository/user_repos.dart';
import 'View/Authentication/authentication.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      BlockExample()


  );
}

class BlockExample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlockExampleState();
  }

}

class BlockExampleState extends State<BlockExample>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ThemekBloc(),
      child: BlocBuilder<ThemekBloc,ThemekState>(
        builder: (BuildContext context,ThemekState themestate){
          print("Called 2334");
          return   MaterialApp(
            theme: themestate.themeData,
            home: BlocProvider(create: (context)=>AlbumsBloc(albumsrepository: Albumsrepository()),
                child:Authentication()),

          );
        },
      ),
    );
  }

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