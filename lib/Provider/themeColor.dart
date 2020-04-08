import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeColor with ChangeNotifier  {
  int _themeColor;
  List _themeColorList = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.black,
    Colors.white,

  ];
  ThemeColor(this._themeColor);
  Color get themeColor => _themeColorList[_themeColor];

  Color anythemeColor(number){
     return _themeColorList[number];
  }
  find() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int color=  prefs.getInt('themeColor');
    _themeColor=color!=null? color:0;
  }
  updata(themeColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeColor', themeColor);
    _themeColor= prefs.getInt('themeColor');
    notifyListeners();
  }
  
}

