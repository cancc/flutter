import 'package:flutter/material.dart';
import 'package:banner/banner.dart';
import '../http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import './hot_list_detail.dart';

class Recommend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecommendState();
  }
}

class _RecommendState extends State<Recommend> {
  var picUrlOne;
  var picUrlTwo;
  var picUrlThree;
  var picUrlFour;
  List hotSongList = [];
  int limit = 10;
  bool isLoading = false;
  bool isMoreData = true;
  //  初始化ScrollController对象，用来监听下滑列表是否是最大下滑位置
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    getPicData();
    getHotSongList();
    //    上拉加载更多
    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent
      ) {
        print('最大下滑位置');
        _getMoreData();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  Future _getMoreData() async {
    if(!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 3),() {
        setState(() {
          if(limit > hotSongList.length) {
            isMoreData = false;
          }
          limit= limit + 10;
          getHotSongList();
          isLoading = false;
        });
      });
    }
  }

//  下拉刷新
  Future _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2),() {
//      print('下拉刷新');
      setState(() {
        getHotSongList();
      });

    });
  }

  //  加载中提示
  Widget loadingTip() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child:  Column(
            children: <Widget>[
              Opacity(
                opacity: isLoading? 1.0 : 0.0,
                child: new CircularProgressIndicator(),
              ),
              Opacity(
                opacity: isMoreData? 0.0 : 1.0,
                child: Text('没有更多数据',style: TextStyle(
                color: Color.fromARGB(255, 255, 205, 50),
                  fontSize: 16.0
              ),),
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 34, 34, 34),
      ),
      child: hotSong(),
    );
  }
  Widget hotSong() {
    if(hotSongList.length==0) {
      return Center(
        child: Text('正在加载中...',style: TextStyle(
          color: Color.fromARGB(255, 255, 205, 50),
          fontSize: 16.0
        ),),
      );
    }else {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: hotSongList.length  +1+2,
          itemBuilder: (BuildContext ctx, int i) {
            if(i > hotSongList.length+1) {
              return loadingTip();
            }else if(i < 1 ) {
              return Container(
                child: BannerView(
                  height: 160.0,
                  data: [
                    picUrlOne,
                    picUrlTwo,
                    picUrlThree,
                    picUrlFour,
                  ],
                  buildShowView: (index, data) {
//              print(data);
                    return Container(
                      child: Image(
                        alignment: Alignment.topLeft,
                        fit: BoxFit.fill,
                        image: NetworkImage(data),
                      ),
                    );
                  },
                  onBannerClickListener: (index, data) {
                    print(index);
                  },
                ),
              );
            }else if(i == 1) {
              return Center(
                child:Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text('热门歌单推荐',style: TextStyle(
                      color: Color.fromARGB(255, 255, 205, 50),
                      fontSize: 16.0
                  ),),
                ),
              );
            }else if(i>1) {
              return GestureDetector(
                onTap: (){
                print(hotSongList[i-2]['id']);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        HotListDetail(
                          id: hotSongList[i-2]['id'],
                          name: hotSongList[i-2]['name']
                        ))
                );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black26))),
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        hotSongList[i-2]['pic'],
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 90.0,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text( hotSongList[i-2]['creator'],style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            ),),
                            Text( hotSongList[i-2]['name'],style: TextStyle(
                                color: Color.fromARGB(77, 255, 255, 255),
                                fontSize: 14.0
                            ),),
                          ],),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      );
    }
}

  getPicData() async {
    var baseUrl = 'https://c.y.qq.com/musichall/fcgi-bin/fcg_yqqhomepagerecommend.fcg?g_tk=5381&format=jsonp&inCharset=utf-8&outCharset=utf-8&notice=0&platform=h5&uin=0&needNewCode=1';
    var response =await HttpUtil().getJson(baseUrl);
    Map<String, dynamic> list = json.decode(response.data);
//    print(list);
//    print(list['data']);
    Map<String, dynamic> dataObj = list['data'];
//    print(dataObj);
    List dataArray = dataObj['slider'];
//    print(dataArray);
    if(mounted) {
      setState(() {
        picUrlOne = dataArray[0]['picUrl'];
        picUrlTwo = dataArray[1]['picUrl'];
        picUrlThree = dataArray[2]['picUrl'];
        picUrlFour = dataArray[3]['picUrl'];
      });
    }

  }
  getHotSongList() async {
    var baseUrl = 'https://api.bzqll.com/music/tencent/hotSongList?key=579621905&categoryId=10000000&sortId=3&limit=$limit';
    var response =await HttpUtil().getJson(baseUrl);

    List list = response.data['data'];
//    print(list);
//    Map<String, dynamic> list = json.decode(response.data);
//    print(list);
////    print(list['data']);
//    Map<String, dynamic> dataObj = list['data'];
////    print(dataObj);
//    List dataArray = dataObj['slider'];
////    print(dataArray);
    if(mounted) {
      setState(() {
        hotSongList = list;
      });
    }

//    print(hotSongList);
  }

}


