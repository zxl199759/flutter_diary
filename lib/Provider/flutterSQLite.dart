import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Sqlite with ChangeNotifier {
  User _user = User();
  List diaryList = [];
  User get user => _user;

  open() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sqlite.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE diarydata(id INTEGER PRIMARY KEY AUTOINCREMENT , diary TEXT  NOT NULL,year INTEGER  NOT NULL,month INTEGER  NOT NULL,day INTEGER  NOT NULL)',
        );
      },
      version: 1,
    );
  }

  //插入
  insert(String text, int year, int month, int day) async {
    final Database db = await open();
    int type = await db.insert(
      'diarydata',
      {
        'diary': text,
        'year': year,
        'month': month,
        'day': day,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    db.close();
    print(type);
    findAll();
  }

  //获取文章表中全部数据
  findAll() async {
    print('findAll');
    final Database db = await open();
    await db.query('diarydata').then((data) {
      diaryList.clear();
      diaryList.addAll(data.reversed);
      notifyListeners();
    });
    db.close();
  }

  //删除
  dele(id) async {
    final Database db = await open();
    int type = await db.delete('diarydata', where: 'id=?', whereArgs: [id]);
    print(type);
    findAll();
  }

  //获取用户数据
  findUser() async {
    await SharedPreferences.getInstance().then(
      (prefs) {
        //名字
        String name = prefs.getString('username');
        //性别
        String sex = prefs.getString('usersex');
        //登录时间
        String firsttime = prefs.getString('userfirsttime');
        //登录验证
        String password = prefs.getString('password');
        //用户头像
        String image = prefs.getString('image');
        print('用户头像' + image.toString());
        //登录验证重置时间
        String passwordtime = prefs.getString('passwordtime');

        DateTime time = DateTime.now();

        _user.setpassword(password != null ? password : '');
        _user.setpasswordtime(passwordtime != null ? passwordtime : '');
        _user..setimage(image != null ? image : '');
        _user.setname(name != null ? name : '未命名');
        _user.setsex(sex != null ? sex : '保密');

        if (firsttime == null) {
          String timetext = time.year.toString() +
              '-' +
              time.month.toString() +
              '-' +
              time.day.toString();
          prefs.setString('userfirsttime', timetext);
          print(timetext);
          _user.setfirsttime(timetext);
        }else{
          _user.setfirsttime(firsttime);
        }

        notifyListeners();
      },
    );
  }

  //修改用户数据
  update(String name, String data) async {
    await SharedPreferences.getInstance().then((prefs) {
      print('修改用户数据');
      print(data);
      prefs.setString(name, data);
      findUser();
    });
  }
}

class User {
  String name;
  String sex;
  String firsttime;
  String image;
  String password;
  String passwordtime;
  User({
    this.name = '未命名',
    this.sex = '保密',
    this.firsttime = '',
    this.image = '',
  });

  setname(name) {
    this.name = name;
  }

  setsex(sex) {
    this.sex = sex;
  }

  setfirsttime(time) {
    this.firsttime = time;
  }

  setimage(image) {
    this.image = image;
  }

  setpassword(password) {
    this.password = password;
  }

  setpasswordtime(passwordtime) {
    this.passwordtime = passwordtime;
  }

  getdays() {
    if (firsttime != '') {
      List time = firsttime.split('-');
      DateTime first =
          DateTime(int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
      return DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .difference(first)
          .inDays;
    } else {
      return '0';
    }
  }

  getpasswordtime() {
    if (passwordtime != '') {
      var time =
          DateTime.now().difference(DateTime.parse(passwordtime)).inSeconds;
      return time;
    }
  }
}
