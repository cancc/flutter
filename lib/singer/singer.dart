import 'package:flutter/material.dart';
import '../http/http.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import './singer_detail.dart';

class Singer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SingerState();
  }
}

class _SingerState extends State<Singer> {
  List singerList = [];
  List hotSinger = [];
  bool isTitle = true;
  @override
  void initState() {
    super.initState();
    getSingerList();
//    hotSinger.addAll(singerList);

  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: singerList.length + hotSinger.length,
      itemBuilder: (context, i) {
        if(i == 0) {
          return Container(
                padding: EdgeInsets.only(left: 20.0),
                height: 30.0,
                color: Color.fromARGB(255, 51, 51, 51),
                child: Row(
                  children: <Widget>[
                    Text('热门',style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(130, 255, 255, 255)
                    ),)
                  ],
                ),
              );
        }
        else if(i<11) {
          return Column(
            children: <Widget>[
              GestureDetector(
                child: Container(

                  child: listCard(hotSinger[i-1]['Fsinger_mid'],
                      hotSinger[i-1]['Fsinger_name']),
                ) ,
                onTap: () {
//                  print(hotSinger[i-1]['Fsinger_mid']);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          SingerDetail(
                            mid: hotSinger[i-1]['Fsinger_mid'],
                            name: hotSinger[i-1]['Fsinger_name'],
                          )
                      )
                  );
                },
              )

            ],
          );
        }
        return Column(
          children: <Widget>[
//            判断首字母是否一致
            singerList[i-11]['Findex'] !=
                singerList[i-10]['Findex']? Container(
              padding: EdgeInsets.only(left: 20.0),
              height: 30.0,
              color: Color.fromARGB(255, 51, 51, 51),
              child: Row(
                children: <Widget>[
                  Text( singerList[i-10]['Findex'],
                    style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(130, 255, 255, 255)
                  ),)
                ],
              ),
            ):Container(
              height: 0.0,
              child: Text(''),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 34, 34),
                  border: null,
                ),
                child: listCard(singerList[i-10]['Fsinger_mid'], singerList[i-10]['Fsinger_name']),
              ),
              onTap: () {
//                print(singerList[i-10]['Fsinger_mid']);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        SingerDetail(
                          mid: singerList[i-10]['Fsinger_mid'],
                          name: singerList[i-10]['Fsinger_name'],
                        )
                    )
                );
              },
            )

          ],
        );
      },
    );
  }
  Widget listCard(mid,name) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      height: 80.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
        border: null,
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 26.0),
            height: 60.0,
            width: 60.0,
            child: CircleAvatar(
//                radius: 50.0,
              backgroundImage: NetworkImage(
                  'http://y.gtimg.cn/music/photo_new/T001R300x300M000$mid.jpg?max_age=2592000'),
            ),
          ),
          Text(name,style: TextStyle(
              color: Color.fromARGB(125, 255, 255, 255),
              fontSize: 15.0
          ),),
        ],
      ),
    );
  }
  getSingerList() async {
    var baseUrl = 'https://c.y.qq.com/v8/fcg-bin/v8.fcg?g_tk=5381&format=jsonp&inCharset=utf-8&outCharset=utf-8&notice=0&channel=singer&page=list&key=all_all_all&pagesize=100&pagenum=1&hostUin=0&platform=yqq&needNewCode=0';
    var response =await HttpUtil().getJson(baseUrl);
//    print(response);
    Map<String, dynamic> list = json.decode(response.data);
    Map<String, dynamic> dataObj = list['data'];
    List dataArray = dataObj['list'];
    if(mounted) {
      setState(() {
        this.hotSinger = dataArray.sublist(0,10);
//        print(this.hotSinger);
        this.singerList = dataArray;
        this.singerList.sort((a,b) => a['Findex'].compareTo((b['Findex'])));

      });
    }
  }


}


