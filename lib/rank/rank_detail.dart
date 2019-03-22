import 'package:flutter/material.dart';
import '../http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../player/player.dart';

class RankDetail extends StatefulWidget {
  RankDetail({Key key, this.id, this.topTitle}) : super(key: key);
  final int id;
  final String topTitle;
  @override
  State<StatefulWidget> createState() {
    return _RankDetail();
  }
}

class _RankDetail extends State<RankDetail> {
  List songList = [];
  List songPartList = [];
  @override
  void initState() {
    super.initState();
    getSongList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.topTitle}'),
      ),
      body: ListView.builder(
        itemCount: songList.length,
        itemBuilder: (BuildContext ctx, int i) {
          return GestureDetector(
            child: Container(
              child: listCard(
                songList[i]['data']['albummid'],
                songList[i]['data']['songname'],
                songList[i]['data']['singer'],
              ),
            ),
            onTap: () {
//              print(songPartList[i]['songmid']);
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

  Widget listCard(albumMid,songName,singerName) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      height: 80.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            height: 60.0,
            width: 60.0,
            child: CircleAvatar(
//                radius: 50.0,
              backgroundImage: NetworkImage(
                  'https://y.gtimg.cn/music/photo_new/T002R300x300M000$albumMid.jpg?max_age=2592000'
              ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 280.0,
                    height: 18.0,
                    child: ListView.builder(
                      scrollDirection : Axis.horizontal,
                      itemCount: singerName.length,
                      itemBuilder: (BuildContext ctx, int i) {
                        return Text( i<singerName.length-1?
                        "${singerName[i]['name']} | ":"${singerName[i]['name']}",
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                            color: Color.fromARGB(125, 255, 255, 255),
                            fontSize: 15.0
                          ),);
                        },
                    )
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
    var baseUrl = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&format=jsonp&inCharset=utf-8&outCharset=utf-8&notice=0&topid=${widget.id}&platform=h5&needNewCode=1&tpl=3&page=detail&type=top';
    var response =await HttpUtil().getJson(baseUrl);
//    print(response);
    Map<String, dynamic> list = json.decode(response.data);
//    print(list);
    List dataArray = list['songlist'];

    if(mounted) {
      setState(() {
        this.songList = dataArray;
        dataArray.forEach((item) {
          songPartList.add({
            "songname": item['data']['songname'],
            "albummid": item['data']['albummid'],
            "songmid":  item['data']['songmid'],
          });
        });
      });
    }
//    print(songList);
//    print(songPartList);

  }


}