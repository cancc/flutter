import 'package:flutter/material.dart';
import '../http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../player/player.dart';


class HotListDetail extends StatefulWidget {
  HotListDetail({Key key, this.id, this.name}) : super(key: key);
  final String id;
  final String name;
  @override
  State<StatefulWidget> createState() {
    return _HotListDetail();
  }
}

class _HotListDetail extends State<HotListDetail> {
  List songList = [];
  List songPartList = []; // 遍历列表提取所需参数

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
              child: listCard(
                songList[i]['id'],
                songList[i]['name'],
                songList[i]['singer'],
              ),
            ),
            onTap: () {
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
            margin: EdgeInsets.only(right: 26.0),
            height: 60.0,
            width: 60.0,
            child: CircleAvatar(
//                radius: 50.0,
              backgroundImage: NetworkImage(
                  "https://api.bzqll.com/music/tencent/pic?id=$albumMid&key=579621905"
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
                children: <Widget>[
                  Container(
                    width: 200.0,
                    child: Text('$singerName',
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
    var baseUrl = 'https://api.bzqll.com/music/tencent/songList?key=579621905&id=${widget.id}';
    var response =await HttpUtil().getJson(baseUrl);
//    print(response);
    Map<String, dynamic> obj = response.data;
//    print(obj['data']['songs']);
//    Map<String, dynamic> dataObj = list['data'];
    List dataArray = obj['data']['songs'];
//    if(mounted) {
    setState(() {
      this.songList = dataArray;
      dataArray.forEach((item) {
        songPartList.add({
          "songname": item['name'],
          "albummid": item['id'],
          "songmid":  item['id'],
        });
      });
    });
//    }
//    print(songList);
  }


}