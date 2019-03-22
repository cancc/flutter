import 'package:flutter/material.dart';
import '../http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import './rank_detail.dart';

class Rank extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RankState();
  }
}

class _RankState extends State<Rank> {
  List topList = [];
  @override
  void initState() {
    super.initState();
    getRankData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 34, 34, 34),
      child:  ListView.builder(
        itemCount: topList.length,
          itemBuilder: (BuildContext ctx, int i) {
            return GestureDetector(
              child: Column(
                  children: <Widget>[
                    listCard(
                      topList[i]['picUrl'],
                      "${topList[i]['songList'][0]['songname']} -- ${topList[i]['songList'][0]['singername']}",
                      "${topList[i]['songList'][1]['songname']} -- ${topList[i]['songList'][1]['singername']}",
                      "${topList[i]['songList'][2]['songname']} -- ${topList[i]['songList'][2]['singername']}",
                    )
                  ]
              ),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      RankDetail(
                        id: topList[i]['id'],
                        topTitle:topList[i]['topTitle'],
                      )
                  )
                );
              },
            );
          }
      )
    );
  }

  Widget listCard(picUrl,title1,title2,title3) {
    return Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Image.network(
                  picUrl,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                Expanded(child: Container(
                  height: 100.0,
                  color: Color.fromARGB(255, 51, 51, 51),
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text( '1 $title1',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: Color.fromARGB(77, 255, 255, 255),
                          fontSize: 15.0
                      ),),
                      Text( '2 $title2',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: Color.fromARGB(77, 255, 255, 255),
                          fontSize: 16.0
                      ),),
                      Text( '3 $title3',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: Color.fromARGB(77, 255, 255, 255),
                          fontSize: 16.0
                      ),),
                    ],),
                )),
              ],
            ),
    );
  }

  getRankData() async {
    var baseUrl = 'https://c.y.qq.com/v8/fcg-bin/fcg_myqq_toplist.fcg?g_tk=5381&inCharset=utf-8&outCharset=utf-8&notice=0&platform=h5&needNewCode=1';
    var response =await HttpUtil().getJson(baseUrl);
//    print(response.data.substring(18,response.data.length));
    var jsonData = response.data.substring(18,response.data.length-1);

    Map<String, dynamic> list = json.decode(jsonData);
//    print(list);
//    print(list['data']);
    List dataArray = list['data']['topList'];
//    print(dataArray);
//    List dataArray = dataObj['slider'];
////    print(dataArray);
    if(mounted) {
      setState(() {
        topList = dataArray;
      });
    }

  }
}


