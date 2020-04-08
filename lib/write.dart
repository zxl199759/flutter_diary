import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:provider/provider.dart';

class Write extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {
  TextEditingController _controller;
  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text='';
    _focusNode = FocusNode();
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
              if (_controller.text.trim() != '') {
                final DateTime time = DateTime.now();
                sqlite.insert(_controller.text.trim(),time.year,time.month,time.day);
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
