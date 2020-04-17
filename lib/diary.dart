import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/myBehavior.dart';
import 'package:flutter_demo/topTime.dart';
import 'package:provider/provider.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    final diaryList = Provider.of<Sqlite>(context).diaryList;
    return SafeArea(
      child: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: <Widget>[
            //头部时间
            TopTime(DateTime.now()),
            Expanded(
              //去除滑动蓝色波纹
              child: ScrollConfiguration(
                //去除原因
                behavior: MyBehavior(),
                child: ListView.builder(
                  itemCount: diaryList.length,
                  itemBuilder: (context, index) {
                    return DiaryFactory(
                      diaryList[index]['id'],
                      diaryList[index]['year'].toString(),
                      diaryList[index]['month'].toString(),
                      diaryList[index]['day'].toString(),
                      diaryList[index]['diary'],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//日记工厂
class DiaryFactory extends StatelessWidget {
  final int id;
  final String year;
  final String month;
  final String day;
  final String text;
  DiaryFactory(this.id, this.year, this.month, this.day, this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Provider.of<Sqlite>(context, listen: false).dele(id);
      },
      onTap: () {
        print('0');
        Navigator.pushNamed(context, '/write', arguments: {
          "id": id,
          "time": DateTime(int.parse(year), int.parse(month), int.parse(day)),
          "text":text,
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                year + '年' + month + '月' + day + '日',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black38,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
