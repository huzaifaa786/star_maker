import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:star_maker/apis/room_api.dart';
import 'package:star_maker/models/song_model.dart';
import 'package:star_maker/utils/ui_lyrics.dart';
import 'package:star_maker/utils/zegocloud_token.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/audio_room/seat_item_view.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/pop_up_manager.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/text_icon_button.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:star_maker/views/live_room/multi_singer_room/components/zego_apply_cohost_list_page.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/business/business_define.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/live_audio_room_manager.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/express/express_service.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/zim/Define/in_room_message_config.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/zim/Define/zim_message.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/zim/zim_service.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/zego_sdk_key_center.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/zego_sdk_manager.dart';

class MultiSingersKaraoke extends StatefulWidget {
  final String roomID;
  final ZegoLiveAudioRoomRole role;
  final Song song;
  const MultiSingersKaraoke(
      {super.key,
      required this.roomID,
      required this.role,
      required this.song});

  @override
  State<MultiSingersKaraoke> createState() => _MultiSingersKaraokeState();
}

class _MultiSingersKaraokeState extends State<MultiSingersKaraoke> {
  final cacheManager = DefaultCacheManager();
  List<ZegoInRoomMessage> messages = [];
  List<StreamSubscription> subscriptions = [];
  final roomApi = new RoomApi();
  TextEditingController textEditingController = TextEditingController();
  String? currentRequestID;
  ValueNotifier<bool> isApplyStateNoti = ValueNotifier(false);
  ZegoInRoomMessageConfig? inRoomMessageConfig = ZegoInRoomMessageConfig();
  ZegoLiveAudioRoomSeatConfig? seatConfig = ZegoLiveAudioRoomSeatConfig();
  final popUpManager = ZegoPopUpManager();

  // ********** LYRICS ****************
  String lyricsContent = "";
  String musicPath = "";
  String lyricsPath = "";
  int playProgress = 0;
  var lyricUI = UILyrics(
    defaultSize: 30,
    defaultExtSize: 20,
  );
  var playing = false;

  var lyricModel = LyricsModelBuilder.create().getModel();
  // ********** LYRICS ****************

  // ********** Music ****************
  ZegoMediaPlayer? mediaPlayer;
  // ********** Music ****************

  @override
  void initState() {
    super.initState();
    final zimService = ZEGOSDKManager().zimService;
    final expressService = ZEGOSDKManager().expressService;
    subscriptions.addAll([
      expressService.roomStateChangedStreamCtrl.stream
          .listen(onExpressRoomStateChanged),
      zimService.roomStateChangedStreamCtrl.stream
          .listen(onZIMRoomStateChanged),
      zimService.connectionStateStreamCtrl.stream
          .listen(onZIMConnectionStateChanged),
      zimService.onInComingRoomRequestStreamCtrl.stream
          .listen(onInComingRoomRequest),
      zimService.onOutgoingRoomRequestAcceptedStreamCtrl.stream
          .listen(onOutgoingRoomRequestAccepted),
      zimService.onOutgoingRoomRequestRejectedStreamCtrl.stream
          .listen(onOutgoingRoomRequestRejected),
      zimService.onBroadcastMessageReceivedEventStreamCtrl.stream
          .listen((event) {})
    ]);
    if (widget.role == ZegoLiveAudioRoomRole.audience) {
      _eventListeners();
    }

    loginRoom();
    loadMusicLyricsData();
  }

  send() {
    if (textEditingController.text.isNotEmpty) {
      ZegoExpressEngine.instance
          .sendBarrageMessage(widget.roomID, textEditingController.text)
          .then((value) {
        if (value.errorCode == 0) {
          final expressService = ZEGOSDKManager().expressService;

          messages.add(ZegoInRoomMessage(
              user: ZegoUser(expressService.currentUser!.userID,
                  expressService.currentUser!.userName),
              message: textEditingController.text,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              messageID: value.messageID));
          textEditingController.clear();
          setState(() {});
        } else {}
      });
    }
  }

  void onIMreceiveMessage(
      String roomID, List<ZegoBarrageMessageInfo> messageList) async {
    for (var msg in messageList) {
      // Check if the message ID already exists in the messages list
      bool isUnique =
          messages.every((element) => element.messageID != msg.messageID);

      if (isUnique) {
        messages.add(ZegoInRoomMessage(
          user: msg.fromUser,
          message: msg.message,
          timestamp: msg.sendTime,
          messageID: msg.messageID,
        ));
      }
    }
    setState(() {});
  }

  loginRoom() async {
    await createRoom();
    await Permission.microphone.request();
    if (widget.role == ZegoLiveAudioRoomRole.host) {
      ZegoExpressEngine.onRoomOnlineUserCountUpdate =
          onRoomOnlineUserCountUpdate;
    }
    ZegoExpressEngine.onIMRecvBarrageMessage = onIMreceiveMessage;
    final token = kIsWeb
        ? ZegoTokenUtils.generateToken(SDKKeyCenter.appID,
            SDKKeyCenter.serverSecret, ZEGOSDKManager().currentUser!.userID)
        : null;
    ZegoLiveAudioRoomManager()
        .loginRoom(widget.roomID, widget.role, token: token)
        .then((result) {
      if (result.errorCode == 0) {
        hostTakeSeat();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('login room failed: ${result.errorCode}')));
      }
    });
  }

  createRoom() async {
    if (widget.role == ZegoLiveAudioRoomRole.host) {
      var data = {
        'room_id': widget.roomID,
        'host_id': ZEGOSDKManager().currentUser!.userID,
        'host_name': ZEGOSDKManager().currentUser!.userName,
        'audience_count': 1,
        'room_type': 'multi',
        'room_status': 'live',
        'song_id': widget.song.id.toString(),
      };
      await roomApi.createRoom(data);
    }
  }

  void sendSEIMessage(int millisecond) {
    var half = lyricModel.lyrics.length / 2;
    if (lyricModel.getCurrentLine(millisecond) > half) {
      setState(() {
        lyricUI = UILyrics(
            defaultSize: 30, defaultExtSize: 20, highlightColor: Colors.blue);
      });
    }

    try {
      Map<String, dynamic> localMusicProcessStatusJsonObject = {
        'KEY_PROGRESS_IN_MS': millisecond,
      };

      String jsonData = jsonEncode(localMusicProcessStatusJsonObject);
      Uint8List data = utf8.encode(jsonData);
      ZegoExpressEngine.instance.sendSEI(
        data,
        data.length,
      );
    } catch (e) {
      print(e);
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
        playProgress = progress;
      });
    } catch (e) {
      print(e);
    }
  }

  onRoomOnlineUserCountUpdate(String roomId, int count) async {
    await roomApi.updateRoomCount(roomId, count);
  }

  _eventListeners() async {
    ZegoExpressEngine.onPlayerRecvSEI = onPlayerRecvSEI;
  }

  setEventHandler() async {
    setState(() {
      playing = true;
    });

    ZegoExpressEngine.onMediaPlayerPlayingProgress =
        (mediaPlayer, millisecond) {
      sendSEIMessage(millisecond);
      setState(() {
        playProgress = millisecond;
      });
    };

    ZegoExpressEngine.onMediaPlayerStateUpdate =
        (mediaPlayer, state, errorCode) {
      setState(() {
        playing = state == ZegoMediaPlayerState.Playing;
      });
    };
    // String streamID = "music" + widget.roomID;

    // await ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  void playSong() async {
    mediaPlayer = await ZegoExpressEngine.instance.createMediaPlayer();
    if (mediaPlayer != null) {
      await mediaPlayer!.enableAux(true);
      await mediaPlayer!
          .loadResource(musicPath)
          .then((ZegoMediaPlayerLoadResourceResult result) => {
                debugPrint(result.errorCode.toString()),
                if (result.errorCode == 0)
                  {
                    mediaPlayer!.start(),
                    setEventHandler(),
                  }
                else
                  {}
              });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mediaPlayer != null) {
      ZegoExpressEngine.instance.destroyMediaPlayer(mediaPlayer!);
    }
    if (widget.role == ZegoLiveAudioRoomRole.host) {
      roomApi.endRoom(widget.roomID);
    }

    ZegoLiveAudioRoomManager().logoutRoom();
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  }

  Future<void> hostTakeSeat() async {
    if (widget.role == ZegoLiveAudioRoomRole.host) {
      //take seat
      await ZegoLiveAudioRoomManager().setSelfHost();
      await ZegoLiveAudioRoomManager()
          .takeSeat(0, isForce: true)
          .then((result) {
        if (mounted &&
            ((result == null) ||
                result.errorKeys
                    .contains(ZEGOSDKManager().currentUser!.userID))) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('take seat failed: $result')));
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('take seat failed: $error')));
      });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            backgroundImage(),
            Positioned(top: 30, left: 10, child: roomTitle()),
            Positioned(top: 30, right: 20, child: leaveButton()),
            Positioned(top: 100, child: seatListView()),
            Positioned(bottom: 270, child: buildReaderWidget()),
            Positioned(bottom: 90, left: 20, child: buildMessagesWidget()),
            Positioned(bottom: 20, left: 0, right: 0, child: bottomView()),
            // messageList(),
          ],
        ),
      ),
    );
  }

  Container buildReaderWidget() {
    return Container(
      color: Colors.black26,
      child: Stack(
        children: [
          LyricsReader(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            model: lyricModel,
            position: playProgress,
            lyricUi: lyricUI,
            playing: playing,
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.3),
            emptyBuilder: () => Center(
              child: Text(
                "No lyrics",
                style: lyricUI.getOtherMainTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget message(ZegoInRoomMessage message) {
    final padding = EdgeInsets.fromLTRB(20, 10, 20, 10);
    return RichText(
      maxLines: null,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Container(
                width: 12 + padding.vertical / 2 - 1,
                height: 12 + padding.vertical / 2 - 1,
                margin: EdgeInsets.only(right: 5),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://robohash.org/${message.user.userID}.png?set=set4',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) {
                    return Text('');
                  },
                )),
          ),
          TextSpan(
            text: message.user.userName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: '\n\t\t         ${message.message}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Stack buildMessagesWidget() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(0),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: const Color(0xff2a2a2a).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Stack(
                          children: [message(messages[index])],
                        ),
                      ),
                    ),
                  ],
                );
              })),
        )
      ],
    );
  }

  Widget backgroundImage() {
    return Image.asset(
      'assets/icons/bg2.jpg',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget roomTitle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('LiveAudioRoom',
                style: Theme.of(context).textTheme.titleMedium),
            Text('Room ID: ${widget.roomID}'),
            ValueListenableBuilder(
              valueListenable: ZegoLiveAudioRoomManager().hostUserNoti,
              builder:
                  (BuildContext context, ZegoSDKUser? host, Widget? child) {
                return host != null
                    ? Text('Host: ${host.userName} (id: ${host.userID})')
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomView() {
    return ValueListenableBuilder<ZegoLiveAudioRoomRole>(
        valueListenable: ZegoLiveAudioRoomManager().roleNoti,
        builder: (context, currentRole, _) {
          if (currentRole == ZegoLiveAudioRoomRole.host) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // message(),
                messageInput(),
                musicButton(),
                // const SizedBox(width: 20),
                lockSeatButton(),
                // const SizedBox(width: 10),
                requestMemberButton(),
                // const SizedBox(width: 10),
                micorphoneButton(),
                // const SizedBox(width: 20),
              ],
            );
          } else if (currentRole == ZegoLiveAudioRoomRole.speaker) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  messageInput(),
                  leaveSeatButton(),
                  micorphoneButton(),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  messageInput(),
                  requestTakeSeatButton(),
                ],
              ),
            );
          }
        });
  }

  // Widget messageList() {
  //   if (inRoomMessageConfig != null) {
  //     if (!inRoomMessageConfig!.visible) {
  //       return Container();
  //     }

  //     var listSize = Size(
  //       inRoomMessageConfig!.width ?? 540,
  //       inRoomMessageConfig!.height ?? 400,
  //     );
  //     if (listSize.width < 54) {
  //       listSize = Size(54, listSize.height);
  //     }
  //     if (listSize.height < 40) {
  //       listSize = Size(listSize.width, 40);
  //     }
  //     return Positioned(
  //       left: 20,
  //       bottom: 85,
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints.loose(listSize),
  //         child: ZegoInRoomLiveMessageView(
  //           config: inRoomMessageConfig!,
  //           avatarBuilder: seatConfig!.avatarBuilder,
  //         ),
  //       ),
  //     );
  //     // return Positioned(
  //     //   left:  20,
  //     //   bottom: 85,
  //     //   child: Text('AAAAAAAAAA',style: Text,)
  //     // );
  //   } else {
  //     return Container();
  //   }
  // }

  Widget lockSeatButton() {
    return ElevatedButton(
        onPressed: () => ZegoLiveAudioRoomManager().lockSeat(),
        child: const Icon(Icons.lock));
  }

  Widget requestMemberButton() {
    return ValueListenableBuilder(
      valueListenable: ZEGOSDKManager().zimService.roomRequestMapNoti,
      builder: (context, Map<String, dynamic> requestMap, child) {
        final requestList = requestMap.values.toList();
        return Badge(
            smallSize: 12,
            isLabelVisible: requestList.isNotEmpty,
            child: child);
      },
      child: ElevatedButton(
        onPressed: () => RoomRequestListView.showBasicModalBottomSheet(context),
        child: const Icon(Icons.link),
      ),
    );
  }

  Widget micorphoneButton() {
    return ValueListenableBuilder(
      valueListenable: ZEGOSDKManager().currentUser!.isMicOnNotifier,
      builder: (context, bool micIsOn, child) {
        return ElevatedButton(
          onPressed: () =>
              ZEGOSDKManager().expressService.turnMicrophoneOn(!micIsOn),
          child: micIsOn ? const Icon(Icons.mic) : const Icon(Icons.mic_off),
        );
      },
    );
  }

  Widget musicButton() {
    return ElevatedButton(
      onPressed: () {
        if (!playing) {
          playSong();
        }
      },
      child: playing ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
    );
  }

  Widget messageInput() {
    // return SizedBox(
    //   height: 100,
    //   width: 200,
    //   child: TextField(
    //     controller: textEditingController,
    //     onSubmitted: (msg) {
    //       send();
    //     },
    //   ),
    // );
    return ZegoInRoomMessageInputBoardButton(
      textEditingController: textEditingController,
      onTap: () {
        send();
        Navigator.of(
          context,
        ).pop();
      },
      rootNavigator: false,
      onSheetPopUp: (int key) {
        // popUpManager.addAPopUpSheet(key);
      },
      onSheetPop: (int key) {
        // popUpManager.removeAPopUpSheet(key);
      },
    );
  }

  // Widget message() {
  //   return SizedBox(
  //     width: 120,
  //     height: 120,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Expanded(
  //           child: GestureDetector(
  //             onTap: () => Navigator.of(
  //               context,
  //             ).pop(),
  //             child: Container(color: Colors.transparent),
  //           ),
  //         ),
  //         ZegoInRoomMessageInput(
  //           placeHolder: '',
  //           backgroundColor: Colors.white,
  //           inputBackgroundColor: const Color(0xffF7F7F8),
  //           textColor: const Color(0xff1B1B1B),
  //           textHintColor: const Color(0xff1B1B1B).withOpacity(0.5),
  //           buttonColor: const Color(0xff0055FF),
  //           onSubmit: () {
  //             Navigator.of(
  //               context,
  //             ).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget requestTakeSeatButton() {
    return ElevatedButton(
      onPressed: () {
        if (!isApplyStateNoti.value) {
          final senderMap = {
            'room_request_type': RoomRequestType.audienceApplyToBecomeCoHost
          };
          ZEGOSDKManager()
              .zimService
              .sendRoomRequest(
                  ZegoLiveAudioRoomManager().hostUserNoti.value?.userID ?? '',
                  jsonEncode(senderMap))
              .then((value) {
            isApplyStateNoti.value = true;
            currentRequestID = value.requestID;
          });
        } else {
          if (currentRequestID != null) {
            ZEGOSDKManager()
                .zimService
                .cancelRoomRequest(currentRequestID ?? '')
                .then((value) {
              isApplyStateNoti.value = false;
              currentRequestID = null;
            });
          }
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isApplyStateNoti,
        builder: (context, isApply, _) {
          return Text(isApply ? 'Cancel Application' : 'Apply Take Seat');
        },
      ),
    );
  }

  Widget leaveSeatButton() {
    return ElevatedButton(
        onPressed: () {
          for (final element in ZegoLiveAudioRoomManager().seatList) {
            if (element.currentUser.value?.userID ==
                ZEGOSDKManager().currentUser!.userID) {
              ZegoLiveAudioRoomManager()
                  .leaveSeat(element.seatIndex)
                  .then((value) {
                ZegoLiveAudioRoomManager().roleNoti.value =
                    ZegoLiveAudioRoomRole.audience;
                isApplyStateNoti.value = false;
                ZEGOSDKManager().expressService.stopPublishingStream();
              });
            }
          }
        },
        child: const Text('Leave Seat'));
  }

  Widget leaveButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/icons/top_close.png',
          color: Colors.white,
        ),
      ),
    );
  }

  void takeSeatResult() {}

  Widget seatListView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: [
          ...List.generate(ZegoLiveAudioRoomManager().seatList.length,
              (seatIndex) {
            return ZegoSeatItemView(
              seatIndex: seatIndex,
              onPressed: () {
                final seat = ZegoLiveAudioRoomManager().seatList[seatIndex];
                if (seatIndex == 0) {
                  // audience can't take host seat.
                  return;
                }
                if (seat.currentUser.value == null) {
                  if (ZegoLiveAudioRoomManager().roleNoti.value ==
                      ZegoLiveAudioRoomRole.audience) {
                    ZegoLiveAudioRoomManager()
                        .takeSeat(seat.seatIndex)
                        .then((result) {
                      if (mounted &&
                          ((result == null) ||
                              result.errorKeys.contains(
                                  ZEGOSDKManager().currentUser!.userID))) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('take seat failed: $result')));
                      }
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('take seat failed: $error')));
                    });
                  } else if (ZegoLiveAudioRoomManager().roleNoti.value ==
                      ZegoLiveAudioRoomRole.speaker) {
                    if (getLocalUserSeatIndex() != -1) {
                      ZegoLiveAudioRoomManager()
                          .switchSeat(getLocalUserSeatIndex(), seat.seatIndex);
                    }
                  }
                } else {
                  if (widget.role == ZegoLiveAudioRoomRole.host &&
                      (ZEGOSDKManager().currentUser!.userID !=
                          seat.currentUser.value?.userID)) {
                    showRemoveSpeakerAndKitOutSheet(
                        context, seat.currentUser.value!);
                  }
                }
              },
            );
          }),
        ],
      ),
    );
  }

  void showRemoveSpeakerAndKitOutSheet(
      BuildContext context, ZegoSDKUser targetUser) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: const Text('remove speaker', textAlign: TextAlign.center),
              onTap: () {
                Navigator.pop(context);
                ZegoLiveAudioRoomManager()
                    .removeSpeakerFromSeat(targetUser.userID);
              },
            ),
            ListTile(
              title: Text(
                  targetUser.isMicOnNotifier.value
                      ? 'mute speaker'
                      : 'unMute speaker',
                  textAlign: TextAlign.center),
              onTap: () {
                Navigator.pop(context);
                ZegoLiveAudioRoomManager().muteSpeaker(
                    targetUser.userID, targetUser.isMicOnNotifier.value);
              },
            ),
            ListTile(
              title: const Text('kick out user', textAlign: TextAlign.center),
              onTap: () {
                Navigator.pop(context);
                ZegoLiveAudioRoomManager().kickOutRoom(targetUser.userID);
              },
            ),
          ],
        );
      },
    );
  }

  int getLocalUserSeatIndex() {
    for (final element in ZegoLiveAudioRoomManager().seatList) {
      if (element.currentUser.value?.userID ==
          ZEGOSDKManager().currentUser!.userID) {
        return element.seatIndex;
      }
    }
    return -1;
  }

  // zim listener
  void onInComingRoomRequest(OnInComingRoomRequestReceivedEvent event) {}

  void onBroadcastMessageReceived(OnBroadcastMessageReceived event) {}

  void onInComingRoomRequestCancelled(
      OnInComingRoomRequestCancelledEvent event) {}

  void onInComingRoomRequestTimeOut() {}

  void onOutgoingRoomRequestAccepted(OnOutgoingRoomRequestAcceptedEvent event) {
    isApplyStateNoti.value = false;
    for (final seat in ZegoLiveAudioRoomManager().seatList) {
      if (seat.currentUser.value == null) {
        ZegoLiveAudioRoomManager().takeSeat(seat.seatIndex).then((result) {
          if (mounted &&
              ((result == null) ||
                  result.errorKeys
                      .contains(ZEGOSDKManager().currentUser!.userID))) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('take seat failed: $result')));
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('take seat failed: $error')));
        });

        break;
      }
    }
  }

  void onOutgoingRoomRequestRejected(OnOutgoingRoomRequestRejectedEvent event) {
    isApplyStateNoti.value = false;
    currentRequestID = null;
  }

  void onExpressRoomStateChanged(ZegoRoomStateEvent event) {
    debugPrint('AudioRoomPage:onExpressRoomStateChanged: $event');
    debugPrint('EXPPPPPPPPPPPPPPPPPPPPPPPPPPPPP: $event');
    if (event.errorCode != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1000),
          content: Text(
              'onExpressRoomStateChanged: reason:${event.reason.name}, errorCode:${event.errorCode}'),
        ),
      );
    }

    if ((event.reason == ZegoRoomStateChangedReason.KickOut) ||
        (event.reason == ZegoRoomStateChangedReason.ReconnectFailed) ||
        (event.reason == ZegoRoomStateChangedReason.LoginFailed)) {
      Navigator.pop(context);
    }
  }

  void onZIMRoomStateChanged(ZIMServiceRoomStateChangedEvent event) {
    debugPrint('AudioRoomPage:onZIMRoomStateChanged: $event');
    debugPrint('ZIMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM: $event');
    if ((event.event != ZIMRoomEvent.success) &&
        (event.state != ZIMRoomState.connected)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1000),
          content: Text('onZIMRoomStateChanged: $event'),
        ),
      );
    }
    if (event.state == ZIMRoomState.disconnected) {
      Navigator.pop(context);
    }
  }

  void onZIMConnectionStateChanged(
      ZIMServiceConnectionStateChangedEvent event) {
    debugPrint('AudioRoomPage:onZIMConnectionStateChanged: $event');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        content: Text('onZIMConnectionStateChanged: $event'),
      ),
    );
    if (event.state == ZIMConnectionState.disconnected) {
      Navigator.pop(context);
    }
  }
}
