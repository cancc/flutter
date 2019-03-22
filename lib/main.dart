import 'package:flutter/material.dart';
import './recommend/recommend.dart';
//import './singer/singer.dart';
import './rank/rank.dart';
import './search/search.dart';
import './singer/singer.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Music',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 34, 34, 34),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 4, child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
             'Music',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 205, 50),
            )
        ),
        bottom: TabBar(
          isScrollable: true, // false将平分排列
          indicatorPadding: EdgeInsets.only(bottom: 6.0),
          indicatorColor: Color.fromARGB(255, 255, 205, 50), // 下边框颜色
          unselectedLabelColor: Color.fromARGB(125, 255, 255, 255), // 失去焦点
          labelColor: Color.fromARGB(255, 255, 205, 50), // 获得焦点字颜色
          labelStyle: TextStyle(
            fontSize: 20.0,
          ),
          tabs: <Widget>[
            Tab(
              text: '推荐',
            ),
            Tab(
              text: '歌手',
            ),
            Tab(
              text: '排行',
            ),
            Tab(
              text: '搜索',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Recommend(),
          Singer(),
          Rank(),
          Search(),
        ],
      ),
    ));
  }
}
