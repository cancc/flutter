import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


enum PlayerState { stopped, playing, paused, next }

class PlayerWidget extends StatefulWidget {
  final List songList;
  final int currentSongIndex;
  PlayerWidget({
    this.songList,
    this.currentSongIndex,
  });

  @override
  State<StatefulWidget> createState() {
    return new _PlayerWidgetState(songList, currentSongIndex);
  }
}

class _PlayerWidgetState extends State<PlayerWidget> with TickerProviderStateMixin{
  String songUrl;
  int currentSongIndex;
  List songList;
  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  PlayerState _playerState = PlayerState.playing;
//  final imgUrl = 'https://dl.stream.qqmusic.qq.com/M500002FAnJU2wkQgy.mp3?vkey=19DB2A083259B7DD53D1303B45ED1FBD54A1DF10C0FEEFFB5526AAD5FCD60EE406920E0C51F0488C0319310B61A2BE49FCAB157B24D846E1&guid=1548164013&uin=0&fromtag=53';

  AnimationController controller;//动画控制器
  CurvedAnimation curved;//曲线动画，动画插值，
  Animation<double> animation;

  bool isLoading = true;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isNext => _playerState == PlayerState.next;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  _PlayerWidgetState(
      this.songList,
      this.currentSongIndex,
      );

  @override
  void initState() {
    super.initState();
    songUrl =  "https://api.bzqll.com/music/tencent/url?key=579621905&id=${songList[currentSongIndex]['songmid']}";
    _initAudioPlayer();
    _audioPlayer.play(songUrl);
//    动画控制器
    controller = new AnimationController(
        vsync: this, duration: const Duration(seconds: 20)
    );
//    动画轨迹
    curved = new CurvedAnimation(parent: controller, curve: Curves.linear);
    controller.addListener(() {
      setState(() {

      });
    });
//    监听旋转一周后的动作
    controller.addStatusListener((status) {
      if(status==AnimationStatus.forward){
        controller.forward();
      }else if(status==AnimationStatus.completed) {
        controller.repeat();
      }else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
    //打开页面就播放动画
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    await dio.download(
      "https://api.bzqll.com/music/tencent/url?key=579621905&id=${songList[currentSongIndex]['songmid']}",
      "${dir.path}/${songList[currentSongIndex]['songname']}.mp3",
      onProgress: (rec, total) {
        print("Rec: $rec, Total: $total,${dir.path}/${songList[currentSongIndex]['songname']}.mp3");
      }
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Image.network(
              "https://api.bzqll.com/music/tencent/pic?id=${songList[currentSongIndex]['songmid']}&key=579621905",
//              'https://y.gtimg.cn/music/photo_new/T002R300x300M000${songList[currentSongIndex]['albummid']}.jpg?max_age=2592000',
              height: 1000.0,
              fit: BoxFit.cover,
            ),
            Container(
              height: 800.0,
              width: 600.0,
              color: Colors.black.withOpacity(0.6),
              child: Text(''),
            ),
            // 模糊滤镜
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: new Container(
                color: Colors.white.withOpacity(0.1),
                height: 800,
              ),
            ),
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 22.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "${songList[currentSongIndex]['songname']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 100.0),
                    height: 320,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(160.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: RotationTransition(
                      turns: curved,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://api.bzqll.com/music/tencent/pic?id=${songList[currentSongIndex]['songmid']}&key=579621905",
//                          'https://y.gtimg.cn/music/photo_new/T002R300x300M000${songList[currentSongIndex]['albummid']}.jpg?max_age=2592000',
                        ),
                      ),
                    )
                ),
                new Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 0.0,20.0 ,0.0),
                          child: Center(
                            child: LinearProgressIndicator(
                              value: 1,
                              valueColor: new AlwaysStoppedAnimation(Colors.grey[300]),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 0.0,20.0 ,0.0),
                          child: Center(
                            child: LinearProgressIndicator(
                              value: _position != null && _position.inMilliseconds > 0
                                  ? _position.inMilliseconds / _duration.inMilliseconds
                                  : 0.0,
                              valueColor: new AlwaysStoppedAnimation(Colors.yellow),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            '${_positionText ?? ''} ',
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          new Text(
                            ' ${_durationText ?? ''}',
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
//                  )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new IconButton(
                        onPressed:  isLoading?() => _pre(): null,
                        iconSize: 36.0,
                        icon: Icon(
                          IconData(0xe603, fontFamily: 'appIconFont'),
                        ),
                        color: Colors.white),
                    new IconButton(
                        onPressed:  _isPlaying ? () {
                          setState(() {
                            _pause();
                            controller.stop();
                          });
                        }:() {
                          setState(() {
                            _play();
                            controller.forward();
                          });
                        } ,
                        iconSize: 36.0,
                        icon: Icon(
                          IconData(_isPlaying? 0xe605:0xe6de, fontFamily: 'appIconFont'),
                        ),
                        color: Colors.white),

//                  new IconButton(
//                      onPressed: _isPlaying || _isPaused ? () => _stop() : null,
//                      iconSize: 64.0,
//                      icon: new Icon(Icons.stop),
//                      color: Colors.cyan),
                    new IconButton(
                        onPressed:  () => _next(),
                        iconSize: 36.0,
                        icon: Icon(
                          IconData(0xe602, fontFamily: 'appIconFont'),
                        ),
                        color: Colors.white),
//                    new IconButton(
//                        onPressed:  downloadFile,
//                        iconSize: 36.0,
//                        icon: Icon(
//                          IconData(0xe682, fontFamily: 'appIconFont'),
//                        ),
//                        color: Colors.white),
                  ],
                ),
              ],
            )
          ],
        )
    );


  }

  void _initAudioPlayer() {
    _audioPlayer = new AudioPlayer();

    _audioPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });

    _audioPlayer.positionHandler = (p) => setState(() {
      _position = p;
    });

    _audioPlayer.completionHandler = () {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    };

    _audioPlayer.errorHandler = (msg) {
//      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = new Duration(seconds: 0);
        _position = new Duration(seconds: 0);
      });
    };
  }

  Future<int> _play() async {
//    print(currentSongMid);
    final result = await _audioPlayer.play(
      "https://api.bzqll.com/music/tencent/url?key=579621905&id=${songList[currentSongIndex]['songmid']}",
    );
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }
//  上一首
  Future<int> _pre() async {
    if(currentSongIndex - 1 ==-1) {
      setState(() {
        currentSongIndex = songList.length-1;
      });
    }else{
      setState(() {
        currentSongIndex = currentSongIndex - 1;
      });
    }
//    print(currentSongIndex);
//    Navigator.pop(context, currentSongMid);
    final result = await _audioPlayer.play(
      "https://api.bzqll.com/music/tencent/url?key=579621905&id=${songList[currentSongIndex]['songmid']}",
    );
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    return result;
  }
//  下一首
  Future<int> _next() async {
    if(currentSongIndex + 1 ==songList.length) {
      setState(() {
        currentSongIndex = 0;
      });
    }else{
      setState(() {
        currentSongIndex = currentSongIndex + 1;
      });
    }
//    print(currentSongIndex);

    final result = await _audioPlayer.play(
      "https://api.bzqll.com/music/tencent/url?key=579621905&id=${songList[currentSongIndex]['songmid']}",
    );
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }
//  暂停
  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = new Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
    _next();
  }
}