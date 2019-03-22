import 'package:flutter/material.dart';
import '../http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../player/player.dart';


class Search extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  List songList = [];
  List songPartList = []; // 遍历列表提取所需参数
  String keyword ;
  @override
  void initState() {
    super.initState();
//    getSongList();
  }
  @override
  Widget build(BuildContext context) {
    return
        Container(
          color: Color.fromARGB(255, 34, 34, 34),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 4.0, 0.0, 4.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        maxLines: 1,
                        style: TextStyle(fontSize: 16.0,color: Colors.white),
                        decoration: new InputDecoration(
                          fillColor: Colors.white,
//                          filled: true,
                          hintText: '歌曲/歌手',
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                        onChanged: (String value) {
                          setState(() {
                          this.keyword = value;
                          });
//                            print(keyword);
                        },
                        onSubmitted: (t) {//内容提交(按回车)的回调
                          getSongList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
             Expanded(
               child:  ListView.builder(
                 itemCount: songList.length,
                 itemBuilder: (BuildContext ctx, int i) {
                   return GestureDetector(
                     child: Container(
                       child: listCard(
                         songList[i]['pic'],
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
             )
            ],
          ),
        );

  }

  Widget listCard(pic,songName,singerName) {
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
              backgroundImage: NetworkImage(pic),
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
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  getSongList() async {
    var baseUrl = 'https://api.bzqll.com/music/tencent/search?key=579621905&s=$keyword&limit=100&offset=0&type=song';
    var response =await HttpUtil().getJson(baseUrl);
    List list = response.data['data'];
//    if(mounted) {
    setState(() {
      this.songList = list;
      list.forEach((item) {
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


