import 'package:flutter/material.dart';
import 'package:flutter_demo/Provider/flutterSQLite.dart';
import 'package:flutter_demo/Provider/themeColor.dart';
import 'package:flutter_demo/diary.dart';
import 'package:flutter_demo/myBehavior.dart';
import 'package:flutter_demo/topTime.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  //日历选中年
  int year;
  //日历选中月
  int month;
  //日历选中日
  int day;
  //星期方格组
  List<Widget> weekdayList = [];
  //日历方格组
  List<Widget> calendarList = [];
  //获取日历高亮时间
  getTime() {
    return DateTime.parse('$year-' +
        '${month > 9 ? '$month' : '0' + '$month'}' +
        '-' +
        '${day > 9 ? '$day' : '0' + '$day'}' +
        ' 01:01:01');
  }

  //获取日历显示月份第一天时间
  getCalendarTime() {
    return DateTime.parse(
        '$year-' + "${month > 9 ? '$month' : '0' + '$month'}" + '-01 01:01:01');
  }

  //判断是否是闰年
  judgeyear(year) {
    if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
      return true;
    } else {
      return false;
    }
  }

  //日期方格组生成方法
  addDay() {
    //获取日历显示月份第一天时间
    DateTime calendarTime = getCalendarTime();
    //二月天数
    int februaryDays = judgeyear(calendarTime.year) ? 29 : 28;
    //每月天数
    List monthdays = [31, februaryDays, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    calendarList.clear();
    //添加日期方格
    if (calendarTime.weekday == 7) {
      for (var a = 1; a <= monthdays[calendarTime.month - 1]; a++) {
        calendarList.add(DayFactory(month, a, getTime(), setTime));
      }
    } else {
      for (var blank = 1; blank <= calendarTime.weekday; blank++) {
        calendarList.add(DayFactory(0, 0, getTime(), setTime));
      }

      for (var a = 1; a <= monthdays[calendarTime.month - 1]; a++) {
        calendarList.add(DayFactory(month, a, getTime(), setTime));
      }
    }
  }

  //星期方格组生成方法
  addWeekday() {
    //星期天数
    List weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    //添加星期方格
    weekdayList.clear();
    for (var weekday = 0; weekday < weekdays.length; weekday++) {
      weekdayList.add(WeekdayFactory(weekdays[weekday]));
    }
  }

  //月份列表生成方法
  addMonths() {
    //添加月份方格
    List<Widget> list = [];
    for (int a = 1; a <= 12; a++) {
      list.add(
        FlatButton(
          textColor: month == a
              ? Provider.of<ThemeColor>(context).themeColor.withOpacity(1)
              : Provider.of<ThemeColor>(context).themeColor.withOpacity(0.3),
          onPressed: () {
            setCalendarTime(a);
            Navigator.pop(context);
          },
          child: Text(a.toString() + '月'),
        ),
      );
    }
    return list;
  }

  //修改日历高亮日期
  setTime(setday) {
    setState(
      () {
        day = setday;
      },
    );
  }

  //修改日历显示月份
  setCalendarTime(setmonth) {
    DateTime time = DateTime.now();
    setState(
      () {
        month = setmonth;
        day = setmonth == time.month ? time.day : 1;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //日历年赋值
    year = DateTime.now().year;
    //日历月赋值
    month = DateTime.now().month;
    //日历日赋值
    day = DateTime.now().day;
  }

  @override
  Widget build(BuildContext context) {
    addWeekday();
    addDay();
    print(getTime());
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            //头部日期
            GestureDetector(
              onTap: () {
                showDialog<Null>(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: Container(
                        color: Colors.white,
                        child: Wrap(
                          children: addMonths(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: TopTime(
                getTime(),
                dayType: false,
              ),
            ),
            //星期
            Row(
              children: weekdayList,
            ),
            //日期
            Wrap(
              children: calendarList,
            ),
            Expanded(child: CalenderDiary(year, month, day))
          ],
        ),
      ),
    );
  }
}

//星期工厂
class WeekdayFactory extends StatelessWidget {
  final String weekday;
  WeekdayFactory(this.weekday);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.width / 7.1,
      width: MediaQuery.of(context).size.width / 7.1,
      color: Colors.white,
      child: Text(weekday),
    );
  }
}

//日期工厂
class DayFactory extends StatelessWidget {
  final int mouth;
  final int day;
  final DateTime time;
  final Function fuc;
  DayFactory(this.mouth, this.day, this.time, this.fuc);

  @override
  Widget build(BuildContext context) {
    //判断是否高亮
    bool type = time.month == mouth && time.day == day;
    //判断是否是空格
    if (day == 0) {
      return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width / 7.1,
        width: MediaQuery.of(context).size.width / 7.1,
        color: Color.fromRGBO(0, 0, 0, 0),
      );
    } else {
      return GestureDetector(
        onTap: () {
          fuc(day);
        },
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.width / 7.1,
          width: MediaQuery.of(context).size.width / 7.1,
          decoration: BoxDecoration(
              color: type
                  ? Provider.of<ThemeColor>(context).themeColor.withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(day.toString()),
        ),
      );
    }
  }
}

class CalenderDiary extends StatelessWidget {
  final int year;
  final int month;
  final int day;
  CalenderDiary(this.year, this.month, this.day);

  @override
  Widget build(BuildContext context) {
    final diaryList = Provider.of<Sqlite>(context).diaryList;
    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      //去除滑动蓝色波纹
      child: ScrollConfiguration(
        //去除原因
        behavior: MyBehavior(),
        child: ListView.builder(
          itemCount: diaryList.length,
          itemBuilder: (context, index) {
            //判断日期
            return Offstage(
              offstage: !(year == diaryList[index]['year'] &&
                  month == diaryList[index]['month'] &&
                  day == diaryList[index]['day']),
              child: DiaryFactory(
                diaryList[index]['id'],
                diaryList[index]['year'].toString(),
                diaryList[index]['month'].toString(),
                diaryList[index]['day'].toString(),
                diaryList[index]['diary'],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FirstDemo extends StatefulWidget {
  @override
  _FirstDemoState createState() => _FirstDemoState();
}

class _FirstDemoState extends State<FirstDemo> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomScrollView(physics: ScrollPhysics(), slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.yellow,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.red,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.yellow,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.red,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            minHeight: 60.0,
            maxHeight: 180.0,
            child: Container(
              color: Colors.yellow,
            ),
          ),
        ),
      ]),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
