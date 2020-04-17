import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:provider/provider.dart';

class Write extends StatefulWidget {
  final Map arguments;
  Write({this.arguments});
  @override
  _WriteState createState() => _WriteState(arguments: this.arguments);
}

class _WriteState extends State<Write> {
  TextEditingController _controller; //输入框控制器
  FocusNode _focusNode; //焦点
  int id; //日记id  没有为null
  DateTime time; //日记时间   没有为null
  final Map arguments; //修改时传入   新建时为null
  _WriteState({this.arguments});
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    if (arguments == null) {
      _controller.text = "";
      time = DateTime.now();
    } else {
      _controller.text = arguments["text"];
      time = arguments["time"];
      id = arguments["id"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final sqlite = Provider.of<Sqlite>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('日记'),
        backgroundColor: Provider.of<ThemeColor>(context).themeColor,
        actions: [
          GestureDetector(
            onTap: () {
              _focusNode.unfocus();
              if (_controller.text.trimRight() != '') {
                sqlite.insert(_controller.text.trimRight(), time.year,
                    time.month, time.day,
                    id: id);
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('你没有写日记哦'),
                    );
                  },
                );
              }
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Center(
                child: Text(
                  '保存',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 100,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: '记录一天生活',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }
}
