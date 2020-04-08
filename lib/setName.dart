import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:provider/provider.dart';

class SetName extends StatefulWidget {
  @override
  _SetNameState createState() => _SetNameState();
}

class _SetNameState extends State<SetName> {
  TextEditingController _controller;
  FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final sqlite = Provider.of<Sqlite>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('修改昵称'),
        backgroundColor: Provider.of<ThemeColor>(context).themeColor,
        actions: [
          GestureDetector(
            onTap: () {
              _focusNode.unfocus();
              if (_controller.text.trim() != '') {
                sqlite.update('username',_controller.text);
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('用户名不许为空'),
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
            maxLength: 7,
            decoration: InputDecoration(
              hintText: '请输入用户名',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }
}
