import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class LogoAnimat extends StatefulWidget {
  @override
  _LogoAnimatState createState() => _LogoAnimatState();
}

class _LogoAnimatState extends State<LogoAnimat> {
  FocusNode focusNode;
  TextEditingController controller;
  Sqlite sqlite;
  //计时器
  Timer timer;
  //剩余时间
  String time;
  //默认最大时间
  int defaultTime;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    time='';
    defaultTime=10;
  }

  //验证
  verification() {
    if (controller.text == sqlite.user.password) {
      controller.text = '';
      Navigator.pushReplacementNamed(context, '/root');
    }
  }

  //保存
  preservation() {
    if (controller.text == '') {
    } else {
      sqlite.update('password', controller.text);
      controller.text = '';
      Navigator.pushReplacementNamed(context, '/root');
    }
  }

  //绑定
  settime() {
    timer?.cancel();
    if (sqlite.user.passwordtime != '') {
      timer = Timer.periodic(new Duration(seconds: 1), (timer) {
        if (sqlite.user.getpasswordtime() > defaultTime) {
          sqlite.update('password', '');
          sqlite.update('passwordtime', '');
        } else {
          setState(() {
            time = (defaultTime - sqlite.user.getpasswordtime()).toString();
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sqlite = Provider.of<Sqlite>(context);
    settime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //背景
          GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: Container(
              color: Colors.blue[100],
            ),
          ),
          //验证区域
          Center(
            heightFactor: 4,
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 0.5),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              //文本框
              child: Column(
                children: <Widget>[
                  TextField(
                    focusNode: focusNode,
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    obscureText: true,
                    decoration: InputDecoration(
                      //保存选项
                      suffix: sqlite.user.password == ''
                          ? GestureDetector(
                              onTap: preservation, child: Text('保存'))
                          : GestureDetector(
                              onTap: verification, child: Text('确定')),
                      hintText:
                          sqlite.user.password == '' ? '请设置登录验证' : '请输入登录验证',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  //底部重置区域
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        //剩余时间显示
                        Container(
                            alignment: Alignment.bottomLeft,
                            child: sqlite.user.passwordtime == ''
                                ? Text('')
                                : Text(time=='' ? time:'$time 秒后重置验证')),
                        //重置选项
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: sqlite.user.passwordtime == ''
                                ? GestureDetector(
                                    onTap: () {
                                      if (sqlite.user.password != '') {
                                        time = defaultTime.toString();
                                        sqlite.update('passwordtime', DateTime.now().toString());
                                      }
                                    },
                                    child: Text(
                                      '验证重置',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      time = '';
                                      sqlite.update('passwordtime', time);
                                    },
                                    child: Text(
                                      '取消重置',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//波浪动画
class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: ControlledAnimation(
          playback: Playback.LOOP,
          duration: Duration(milliseconds: (5000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, value) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value + offset),
            );
          }),
    );
  }
}

//画波浪
class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white.withAlpha(60)
      ..style = PaintingStyle.fill;

    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
