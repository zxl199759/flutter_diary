import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:flutter_demo/logoAnimat.dart';
import 'package:flutter_demo/router.dart';
import 'package:provider/provider.dart';




main() {
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: Sqlite()),
      ChangeNotifierProvider.value(value: ThemeColor(0)),
    ],
    child:  MyApp(),
  )
   
    );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Provider.of<Sqlite>(context,listen: false)..findUser()..findAll();
    Provider.of<ThemeColor>(context,listen: false).find();
    
  }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,  
      home: Scaffold(
        body:LogoAnimat(),
      ),   
    );
  }
}