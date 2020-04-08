import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:flutter_demo/calendar.dart';
import 'package:flutter_demo/diary.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//主页面
class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int _pageIndex;
  List<Widget> _pageList;

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    //添加日记页面与日历页面
    _pageList = []..add(Diary())..add(Calendar());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(),
      body: _pageList[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            title: Text('日记'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('日历'),
          ),
        ],
        currentIndex: _pageIndex,
        fixedColor: Provider.of<ThemeColor>(context).themeColor,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Provider.of<ThemeColor>(context).themeColor,
        child: Icon(Icons.add),
        onPressed: () => {Navigator.pushNamed(context, '/write')},
      ),
    );
  }
}

//侧滑页面
class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('侧滑页面');
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Color.fromRGBO(250, 250, 250, 1),
      child: Column(
        children: <Widget>[
          //头饰
          DrawerPageTop(),
          //用户头像姓名与记录
          UserImage(),
          //用户信息
          UserInformation(),
          //修改主题颜色
          SetThemeColor(),
        ],
      ),
    );
  }
}

//侧滑页面头饰
class DrawerPageTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Provider.of<ThemeColor>(context).themeColor,
    );
  }
}

//侧滑页面用户头像姓名与记录
class UserImage extends StatelessWidget {
  //记录天数格式
  getWidget(title, text, color) {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: color.withOpacity(0.5),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: color.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setImage(context, sqlite) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('相机'),
                onTap: () {
                  camera(sqlite);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('相册'),
                onTap: () {
                  gallery(sqlite);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //相册
  gallery(sqlite) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then(
      (image) async {
        List<int> imageBytes = await image.readAsBytes();
        String imageString = convert.base64Encode(imageBytes);
        print(imageString);
        sqlite.update('image', imageString);
      },
    );
  }

  //拍照
  camera(sqlite) async {
    await ImagePicker.pickImage(source: ImageSource.camera).then(
      (image) async {
        List<int> imageBytes = await image.readAsBytes();
        String imageString = convert.base64Encode(imageBytes);
        print(imageString);
        sqlite.update('image', imageString);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Provider.of<ThemeColor>(context).themeColor;
    final sqlite = Provider.of<Sqlite>(context);
    print('头像姓名与记录');
    return Container(
        child: Column(
      children: <Widget>[
        //头像
        GestureDetector(
          onTap: () {
            setImage(context, sqlite);
          },
          child: Container(
            margin: EdgeInsets.only(top: 33),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: sqlite.user.image == ''
                    ? AssetImage('lib/images/defaultUser.jpg')
                    : MemoryImage(convert.base64Decode(sqlite.user.image)),
                fit: BoxFit.cover,
              ),
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
          ),
        ),
        //姓名
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            Provider.of<Sqlite>(context).user.name,
            style: TextStyle(
              fontSize: 18,
              color:
                  Provider.of<ThemeColor>(context).themeColor.withOpacity(0.5),
            ),
          ),
        ),
        //日记信息
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            children: <Widget>[
              //记录天数
              getWidget('记录天数', '${sqlite.user.getdays()} 天', color),
              //共计篇数
              getWidget('记录篇数', '${sqlite.diaryList.length} 篇', color),
            ],
          ),
        )
      ],
    ));
  }
}

//侧滑页面用户信息
class UserInformation extends StatelessWidget {
  //行格式
  getList(title, text, Color color, fut) {
    return GestureDetector(
      onTap: () => fut(),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: color.withOpacity(0.5),
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: color.withOpacity(0.5),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('侧滑页面用户信息');
    final color = Provider.of<ThemeColor>(context).themeColor;
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          getList(
            '用户名',
            Provider.of<Sqlite>(context).user.name,
            color,
            () => {Navigator.pushNamed(context, '/setName')},
          ),
          getList(
            '性别',
            Provider.of<Sqlite>(context).user.sex,
            color,
            () => {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    final sqlite = Provider.of<Sqlite>(context, listen: false);
                    result(String sex) {
                      sqlite.update('usersex', sex);
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text("男")),
                          onTap: () async {
                            result('男');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Center(child: Text("女")),
                          onTap: () async {
                            result('女');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Center(child: Text("保密")),
                          onTap: () async {
                            result('保密');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  })
            },
          ),
          getList('注册时间', Provider.of<Sqlite>(context).user.firsttime, color,
              () => {}),
        ],
      ),
    );
  }
}

//侧滑页面修改主题颜色
class SetThemeColor extends StatelessWidget {
  getWidget(length, themeColorProvider, number) {
    final type = themeColorProvider.anythemeColor(number) ==
        themeColorProvider.themeColor;
    return GestureDetector(
      onTap: () => themeColorProvider.updata(number),
      child: Container(
        margin: EdgeInsets.all(length * 0.1),
        height: type ? length * 1.04 : length * 0.98,
        width: type ? length * 1.04 : length * 0.98,
        decoration: BoxDecoration(
          color: themeColorProvider.anythemeColor(number),
          borderRadius: BorderRadius.all(Radius.circular(length * 0.2)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);
    final lenght = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              '主题颜色',
              style: TextStyle(
                fontSize: 20,
                color: themeColorProvider.themeColor.withOpacity(0.5),
              ),
            ),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              getWidget(lenght / 6, themeColorProvider, 0),
              getWidget(lenght / 6, themeColorProvider, 1),
              getWidget(lenght / 6, themeColorProvider, 2),
              getWidget(lenght / 6, themeColorProvider, 3),
              getWidget(lenght / 6, themeColorProvider, 4),
              getWidget(lenght / 6, themeColorProvider, 5),
            ],
          )
        ],
      ),
    );
  }
}
