import 'package:flutter/material.dart';
import 'package:flutter_demo/logoAnimat.dart';
import 'package:flutter_demo/root.dart';
import 'package:flutter_demo/setName.dart';
import 'package:flutter_demo/write.dart';






final routes={
      '/logoAnimat':(context)=>LogoAnimat(),
      '/setName':(context)=>SetName(),
      '/write':(context)=>Write(),
      '/root':(context)=>Root(),
};

//固定写法

var onGenerateRoute=(RouteSettings settings) {
      // 统一处理
      final String name = settings.name; 
      final Function pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        if (settings.arguments != null) {
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context, arguments: settings.arguments));
          return route;
        }else{
            final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context));
            return route;
        }
      }
};
