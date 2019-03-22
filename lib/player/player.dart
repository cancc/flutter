import 'package:flutter/material.dart';
//import '../http/http.dart';
//import 'package:audioplayers/audioplayers.dart';
import './player_widget.dart';
//import 'package:audioplayers/audio_cache.dart';


class Player extends StatefulWidget {
  Player({Key key,
    this.songPartList,
    this.currentSongIndex,
  }) : super(key : key);
  final List songPartList;
  final int currentSongIndex;

  @override
  State<StatefulWidget> createState() {
    return _Player();
  }
}

class _Player extends State<Player> {
  @override
  void initState() {
    super.initState();
//    print(widget.currentSongIndex);
  }
  @override
  Widget build(BuildContext context) {
    return PlayerWidget(
      songList: widget.songPartList,
      currentSongIndex: widget.currentSongIndex,
    );
  }
}


