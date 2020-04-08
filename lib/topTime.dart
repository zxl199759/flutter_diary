import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:provider/provider.dart';

class TopTime extends StatelessWidget {
  final time;
  final bool monthType;
  final bool dayType;
  TopTime(this.time, {this.monthType = true, this.dayType = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      color: Provider.of<ThemeColor>(context).themeColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            time.year.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            (monthType ? (time.month.toString() + '月') : '') +
                (dayType ? (time.day.toString() + '日') : ''),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
