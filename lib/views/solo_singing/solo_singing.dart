import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:star_maker/apis/room_api.dart';
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
  final roomApi = new RoomApi();
  int playProgress = 0;
  int audiencePlayProgress = 0;
  String lyricsContent = "";
  String musicPath = "";
  String lyricsPath = "";

  // Pitch Configuration
  ZegoVoiceChangerPreset? _changerPreset;
  late bool _changerCustomParam;
  late double _pitch;
  late bool _changerPresetEnable;
  late bool _pitchEnable;

  // Record path
  String? recordPath;

  var lyricUI = UINetease();
  var playing = false;
  var isStarted = false;
  var lyricModel = LyricsModelBuilder.create().bindLyricToMain('').getModel();
  ZegoEngineProfile profile = ZegoEngineProfile(
    653933933,
    ZegoScenario.Karaoke,
    appSign: "17be0bfe3337e6f57bcd98b8975b771a733ef9b344c08978c41a2c77f2b34b40",
  );

  ZegoMediaPlayer? player;

  void pauseSong() {
    player?.pause();
    setState(() {
      playing = false;
    });
  }

  void resumeSong() {
    !isStarted ? startSinging() : null;
    player?.resume();
    setState(() {
      playing = true;
    });
  }

  void restartSong() {
    if (player != null) {
      ZegoExpressEngine.instance.destroyMediaPlayer(player!);
    }
    stopRecording();

    player?.seekTo(0);
    // player?.start();
    setState(() {
      playProgress = 0;
      playing = false;
      // playing = true;
    });
    if (recordPath != null) startPlay(recordPath!);
  }

  void onCapturedDataRecordStateUpdate(ZegoDataRecordState state, int errorCode,
      ZegoDataRecordConfig config, ZegoPublishChannel channel) {
    print("RECORD PATH: $recordPath");
    if (state == ZegoDataRecordState.NoRecord) {
      print('RECORDING: No record noooooooooooooooooooooooooooooo ....');
    } else if (state == ZegoDataRecordState.Recording) {
      print('RECORDING: record yessssssssssssssssssssssssssssssss ...');
    } else {
      print('RECORDING: saved saveddddddddddddddddddddddddddd ...');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              titlePadding: EdgeInsets.all(0),
              title: Center(child: Text('Recording')),
              children: [SelectableText('Log path:$recordPath')],
            );
          });
    }
    setState(() {});
  }

  loginRoom() async {
    await createRoom();
    await Permission.microphone.request();
    if (widget.isHost == true) {
      ZegoExpressEngine.onRoomOnlineUserCountUpdate =
          onRoomOnlineUserCountUpdate;
      ZegoExpressEngine.onCapturedDataRecordStateUpdate =
          onCapturedDataRecordStateUpdate;
    }

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

  onRoomOnlineUserCountUpdate(String roomId, int count) async {
    await roomApi.updateRoomCount(roomId, count);
  }

  createRoom() async {
    if (widget.isHost == true) {
      var data = {
        'room_id': widget.roomID,
        'host_id': widget.userID,
        'host_name': widget.userID + '_user',
        'audience_count': 1,
        'room_type': 'solo',
        'room_status': 'live',
        'song_id': widget.song.id.toString(),
      };
      await roomApi.createRoom(data);
    }
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
      isStarted = true;
    });
    Random random = new Random();
    int randomInt = random.nextInt(1000);
    String streamID = "stream1" + randomInt.toString();

    await ZegoExpressEngine.instance.muteMicrophone(false);
    await ZegoExpressEngine.instance.startPublishingStream(streamID);
    startRecording();
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

  Widget customSlider(
      {required double value,
      required Function(double)? onChanged,
      double max = 100.0,
      double min = 0.0,
      bool enable = true}) {
    return Slider(
      value: value,
      onChanged: enable ? onChanged : null,
      max: max,
      min: min,
      activeColor: enable ? Colors.blue : Colors.grey,
      inactiveColor: enable ? Colors.blue[100] : Colors.grey,
    );
  }

  void onVoiceChangerPreset(ZegoVoiceChangerPreset? mode) {
    if (mode != null) {
      setState(() {
        _changerPreset = mode;
      });
      ZegoExpressEngine.instance.setVoiceChangerPreset(mode);
    }
  }

  void onPitchChanged(double value) {
    setState(() {
      _pitch = value;
      ZegoExpressEngine.instance
          .setVoiceChangerParam(ZegoVoiceChangerParam(_pitch));
    });
  }

  void onChangerCustomParamSwitchChanged(bool b) {
    setState(() {
      _changerCustomParam = b;
      _changerPresetEnable = !_changerCustomParam;
      _pitchEnable = _changerCustomParam;
    });

    if (b) {
      ZegoExpressEngine.instance
          .setVoiceChangerParam(ZegoVoiceChangerParam(_pitch));
    } else {
      ZegoExpressEngine.instance.setVoiceChangerPreset(_changerPreset!);
    }
  }

  void startRecording() {
    if (recordPath != null) {
      ZegoExpressEngine.instance.startRecordingCapturedData(
          ZegoDataRecordConfig(recordPath!, ZegoDataRecordType.OnlyAudio));
    }
  }

  void stopRecording() {
    print('STPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');
    ZegoExpressEngine.instance.stopRecordingCapturedData();
  }

  startPlay(String path) async {
    print('START PLATYPE: ' + path);
    if (player == null) {
      player = await ZegoExpressEngine.instance.createMediaPlayer();
      await ZegoExpressEngine.instance.muteMicrophone(false);
    }

    await player?.loadResource(path).then((value) => {
          debugPrint("HELLO : ${value.errorCode.toString()}"),
          if (value.errorCode == 0)
            {
              player!.start(),
            }
        });

    // if (result != null && result.errorCode == 0) {
    //   print('📥 MediaPlayer load resource: $path success');
    //   player!.start();
    //   print('📥 MediaPlayer start');
    // } else {
    //   print(
    //       '📥 MediaPlayer load resource: $path fail, errorCode: ${result?.errorCode}');
    // }
  }

  @override
  void initState() {
    _changerPreset = ZegoVoiceChangerPreset.None;
    _changerCustomParam = false;
    _pitch = 0.0;
    _pitchEnable = false;
    _changerPresetEnable = true;
    loadMusicLyricsData();
    loginRoom();
    getExternalStorageDirectory().then((value) {
      recordPath = value != null ? value.absolute.path + '/record.mp3' : null;
    });

    super.initState();
  }

  @override
  void dispose() {
    if (widget.isHost == true) {
      roomApi.endRoom(widget.roomID);
    }
    stopRecording();
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
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                      onPressed: playing ? pauseSong : resumeSong,
                    ),
                    IconButton(
                      icon: Icon(Icons.replay),
                      onPressed: restartSong,
                    ),
                  ],
                )
              : SizedBox(),
          isHost
              ? Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                    children: [
                      Row(children: [
                        Text('Preset'),
                        DropdownButton(
                            value: _changerPreset,
                            onChanged: onVoiceChangerPreset,
                            items: _changerPresetEnable
                                ? ZegoVoiceChangerPreset.values.map<
                                    DropdownMenuItem<
                                        ZegoVoiceChangerPreset>>((value) {
                                    return DropdownMenuItem<
                                        ZegoVoiceChangerPreset>(
                                      child: Text(
                                          '${value.toString().replaceAll('ZegoVoiceChangerPreset.', '')}'),
                                      value: value,
                                    );
                                  }).toList()
                                : <DropdownMenuItem<ZegoVoiceChangerPreset>>[]),
                        Expanded(child: Container()),
                        Text('Custom parameter'),
                        Switch(
                            value: _changerCustomParam,
                            onChanged: onChangerCustomParamSwitchChanged),
                      ]),
                      Row(children: [
                        Text('pitch'),
                        Expanded(
                            child: customSlider(
                                value: _pitch,
                                onChanged: onPitchChanged,
                                min: -8.0,
                                max: 8.0,
                                enable: _pitchEnable)),
                      ]),
                    ],
                  ))
              : SizedBox()
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

// class AudioEffectsBottomSheet extends StatefulWidget {
//   final ZegoExpressEngine zegoEngine;

//   AudioEffectsBottomSheet({required this.zegoEngine});

//   @override
//   _AudioEffectsBottomSheetState createState() =>
//       _AudioEffectsBottomSheetState();
// }

// class _AudioEffectsBottomSheetState extends State<AudioEffectsBottomSheet> {
//   double _pitchValue = 0.0;
//   double _echoValue = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with default values or retrieve from the Zego SDK
//     ZegoVoiceChangerParam voiceChangerParam = new ZegoVoiceChangerParam(0.0);
//     _pitchValue = voiceChangerParam.pitch;

//     _echoValue = widget.zegoEngine.getEchoIntensity();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text("Pitch"),
//             Slider(
//               value: _pitchValue,
//               min: -3.0,
//               max: 3.0,
//               onChanged: (value) {
//                 setState(() {
//                   _pitchValue = value;
//                 });
//                 widget.zegoEngine.setPitchShift(value);
//               },
//             ),
//             SizedBox(height: 16),
//             Text("Echo"),
//             Slider(
//               value: _echoValue,
//               min: 0.0,
//               max: 1.0,
//               onChanged: (value) {
//                 setState(() {
//                   _echoValue = value;
//                 });
//                 widget.zegoEngine.setEchoIntensity(value);
//               },
//             ),
//             // Add more controls for other effects as needed
//           ],
//         ),
//       ),
//     );
//   }
// }
