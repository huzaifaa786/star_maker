import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star_maker/models/song_model.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class SoloSingView extends StatefulWidget {
  final String roomID;
  final String userID;
  final bool isHost;
  final Song song;
  const SoloSingView({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.song,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<SoloSingView> createState() => _SoloSingViewState();
}

class _SoloSingViewState extends State<SoloSingView> {
  final cacheManager = DefaultCacheManager();
  String userID = "";
  String roomID = "";
  String userName = "";
  String singerCurrentLyrics = "";
  String currentLyrics = "";
  bool isHost = false;
  Map<Duration, String>? lyrics;

  int playProgress = 0;
  int audiencePlayProgress = 0;
  String lyricsContent = "";
  String musicPath = "";
  String lyricsPath = "";
  var lyricUI = UINetease();
  var playing = false;
  var lyricModel = LyricsModelBuilder.create().bindLyricToMain('').getModel();
  ZegoEngineProfile profile = ZegoEngineProfile(
    653933933,
    ZegoScenario.Karaoke,
    appSign: "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
  );

  ZegoMediaPlayer? player;

  loginRoom() async {
    await Permission.microphone.request();

    await ZegoExpressEngine.createEngineWithProfile(profile);
    setEventHandler();
    userID = widget.userID;
    userName = widget.userID;
    roomID = widget.roomID;
    isHost = widget.isHost;
    ZegoUser user = ZegoUser(userID, userName);
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
      ..isUserStatusNotify = true;
    await ZegoExpressEngine.instance
        .loginRoom(roomID, user, config: roomConfig);
    if (isHost) {
      await createMediaPlayer();
    }
    setState(() {});
  }

  loadMusicLyricsData() async {
    var fetchLyricsFile =
        await cacheManager.getSingleFile(widget.song.lyrics_file_url!);
    var fetchMusicFile =
        await cacheManager.getSingleFile(widget.song.music_file_url!);
    musicPath = fetchMusicFile.path;
    lyricsPath = fetchLyricsFile.path;

    await fetchLyricsFile.readAsString().then((value) {
      setState(() {
        lyricsContent = value;
      });
    });

    lyricModel =
        LyricsModelBuilder.create().bindLyricToMain(lyricsContent).getModel();
    setState(() {});
  }

  Future<Map<Duration, String>> parseLyrics(lyrics) async {
    Map<Duration, String> lyricsTimingMap = {};
    for (final lcr in lyrics) {
      Duration timestamp = Duration(
          milliseconds: int.parse(lcr.startTimeMillisecond.toString()));
      lyricsTimingMap[timestamp] = lcr.content;
    }
    return lyricsTimingMap;
  }

  void onRoomStateUpdated(String roomID, ZegoUpdateType updateType,
      List<ZegoStream> streamList, extendedData) {
    ZegoStream stream = streamList.first;
    String playStreamID = stream.streamID;
    if (updateType == ZegoUpdateType.Add) {
      ZegoExpressEngine.instance
          .setPlayStreamBufferIntervalRange(playStreamID, 500, 4000);
      ZegoExpressEngine.instance.startPlayingStream(playStreamID);
    } else {
      ZegoExpressEngine.instance.stopPlayingStream(playStreamID);
    }
  }

  void onPlayerRecvSEI(String streamID, Uint8List data) {
    String dataString = utf8.decode(data);
    try {
      Map<String, dynamic> jsonObject = jsonDecode(dataString);
      String KEY_PROGRESS_IN_MS = "KEY_PROGRESS_IN_MS";
      int progress = jsonObject[KEY_PROGRESS_IN_MS];

      setState(() {
        playing = true;
        audiencePlayProgress = progress;
      });
    } catch (e) {
      print(e);
    }
  }

  void onIMRecvCustomCommand(
      String roomID, ZegoUser fromUser, String command) {}

  setEventHandler() async {
    ZegoExpressEngine.onRoomStreamUpdate = onRoomStateUpdated;
    ZegoExpressEngine.onPlayerRecvSEI = onPlayerRecvSEI;
    ZegoExpressEngine.onIMRecvCustomCommand = onIMRecvCustomCommand;
  }

  void onMediaPlayerPlayingProgress(
      ZegoMediaPlayer player, int miliseconds) async {
    setState(() {
      playProgress = miliseconds;
    });
    // Send SEI infomations
    sendSEIMessage(miliseconds);
  }

  onMediaPlayerStateUpdate(ZegoMediaPlayer mediaPlayer,
      ZegoMediaPlayerState state, int errorCode) async {
    if (state == ZegoMediaPlayerState.PlayEnded) {
      // stopSinging();
    }
  }

  loadMusicResource() async {
    await player!.loadResource(musicPath).then((value) => {
          if (value.errorCode == 0)
            {
              player!.start(),
            }
        });
  }

  void startSinging() async {
    await loadMusicResource();
    setState(() {
      playing = true;
    });
    Random random = new Random();
    int randomInt = random.nextInt(1000);
    String streamID = "stream1" + randomInt.toString();

    await ZegoExpressEngine.instance.muteMicrophone(false);
    await ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  createMediaPlayer() async {
    ZegoMediaPlayer? mediaPlayer =
        await ZegoExpressEngine.instance.createMediaPlayer();
    if (mediaPlayer == null) {
      return;
    }

    player = mediaPlayer;
    player!.enableAux(true);

    ZegoExpressEngine.onMediaPlayerPlayingProgress =
        onMediaPlayerPlayingProgress;
    ZegoExpressEngine.onMediaPlayerStateUpdate = onMediaPlayerStateUpdate;
    setState(() {});
  }

  void sendSEIMessage(int millisecond) {
    try {
      Map<String, dynamic> localMusicProcessStatusJsonObject = {
        'KEY_PROGRESS_IN_MS': millisecond,
      };
      String jsonData = jsonEncode(localMusicProcessStatusJsonObject);
      Uint8List data = utf8.encode(jsonData);
      ZegoExpressEngine.instance.sendSEI(data, data.length);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    loadMusicLyricsData();
    loginRoom();
    super.initState();
  }

  @override
  void dispose() {
    ZegoExpressEngine.destroyEngine();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
          child: Column(
        children: [
          isHost ? buildReaderWidget() : buildAudienceReaderWidget(),
          isHost
              ? MaterialButton(
                  child: Text('Start Singing'),
                  onPressed: () {
                    startSinging();
                  },
                )
              : Text(''),
        ],
      )),
    );
  }

  LyricsReader buildReaderWidget() {
    return LyricsReader(
      padding: EdgeInsets.symmetric(horizontal: 0),
      model: lyricModel,
      position: playProgress,
      lyricUi: lyricUI,
      playing: playing,
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.5),
      emptyBuilder: () => Center(
        child: Text(
          "No lyrics",
          style: lyricUI.getOtherMainTextStyle(),
        ),
      ),
    );
  }

  LyricsReader buildAudienceReaderWidget() {
    return LyricsReader(
      padding: EdgeInsets.symmetric(horizontal: 0),
      model: lyricModel,
      position: audiencePlayProgress,
      lyricUi: lyricUI,
      playing: playing,
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.5),
      emptyBuilder: () => Center(
        child: Text(
          "No lyrics",
          style: lyricUI.getOtherMainTextStyle(),
        ),
      ),
    );
  }
}

class LyricsWidget extends StatefulWidget {
  final Map<Duration, String> lyrics;
  final String currentLyrics;

  LyricsWidget({required this.lyrics, required this.currentLyrics});

  @override
  _LyricsWidgetState createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> {
  ScrollController _scrollController = ScrollController();
  int _currentLyricIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollToCurrentLyric();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  void _scrollToCurrentLyric() {
    if (_currentLyricIndex >= 0 && _currentLyricIndex < widget.lyrics.length) {
      _scrollController.animateTo(
        _currentLyricIndex *
            20.0, // Adjust the value to control the scrolling speed
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateCurrentLyricIndex(int timestamp) {
    Duration currentDuration = widget.lyrics.keys.firstWhere(
      (duration) => duration.inMilliseconds > timestamp,
      orElse: () => widget.lyrics.keys.last,
    );
    int newIndex = widget.lyrics.keys.toList().indexOf(currentDuration);
    setState(() {
      _currentLyricIndex = newIndex;
    });
    _scrollToCurrentLyric();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.lyrics.length,
      itemBuilder: (context, index) {
        bool isCurrentLyric = index == _currentLyricIndex;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.lyrics[widget.lyrics.keys.toList()[index]]!,
            style: TextStyle(
              fontSize: 16.0,
              color: isCurrentLyric ? Colors.blue : Colors.black,
              fontWeight: isCurrentLyric ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
