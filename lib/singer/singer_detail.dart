import 'package:flutter/material.dart';
import '../http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../player/player.dart';


class SingerDetail extends StatefulWidget {
  SingerDetail({Key key, this.mid, this.name}) : super(key: key);
  final String mid;
  final String name;
  @override
  State<StatefulWidget> createState() {
    return _SingerDetail();
  }
}

class _SingerDetail extends State<SingerDetail> {

  List songList = [];
  List songPartList = []; //  自定义数组保存所需数据
  @override
  void initState() {
    super.initState();
    getSongList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
      ),
      body: ListView.builder(
        itemCount: songList.length,
        itemBuilder: (BuildContext ctx, int i) {
          return GestureDetector(
            child: Container(
                child:  listCard(
                  songList[i]['musicData']['albummid'],
                  songList[i]['musicData']['songname'],
                  songList[i]['musicData']['singer'][0]['name'],
                  songList[i]['musicData']['albumname'],
                ),
            ),
            onTap: () {
//              print(songList[i]['musicData']['songmid']);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                    Player(
                      songPartList: songPartList,
                      currentSongIndex: i,
                    )
                  )
              );
            },
          );
        },
      ),
    );
  }

  Widget listCard(albumMid,songName,singerName,albumName) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      height: 80.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
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
                  'https://y.gtimg.cn/music/photo_new/T002R300x300M000$albumMid.jpg?max_age=2592000'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 200.0,
                child: Text('$songName',
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                ),),
              ),
              Row(
                children: <Widget>[
                  Text('$singerName', style: TextStyle(
                      color: Color.fromARGB(125, 255, 255, 255),
                      fontSize: 15.0
                  ),),
                  Text('--', style: TextStyle(
                      color: Color.fromARGB(125, 255, 255, 255),
                      fontSize: 15.0
                  ),),
                  Container(
                    width: 150.0,
                    child: Text('$albumName',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          color: Color.fromARGB(125, 255, 255, 255),
                          fontSize: 15.0
                      ),),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
  getSongList() async {
    var baseUrl = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_singer_track_cp.fcg?g_tk=5381&format=jsonp&inCharset=utf-8&outCharset=utf-8&notice=0&hostUin=0&platform=yqq&needNewCode=0&singermid=${widget.mid}&order=listen&begin=0&num=100';
    var response =await HttpUtil().getJson(baseUrl);
//    print(response);
    Map<String, dynamic> list = json.decode(response.data);
    Map<String, dynamic> dataObj = list['data'];
    List dataArray = dataObj['list'];
//    if(mounted) {
      setState(() {
        this.songList = dataArray;
        dataArray.forEach((item) {
          songPartList.add({
            "songname": item['musicData']['songname'],
            "albummid": item['musicData']['albummid'],
            "songmid":  item['musicData']['songmid'],
          });
        });
      });
//    }
//    print(songList);
//    print(songPartList);

  }
}

