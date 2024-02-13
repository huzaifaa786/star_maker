// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:star_maker/apis/room_api.dart';
import 'package:star_maker/apis/song_api.dart';
import 'package:star_maker/models/room_model.dart';
import 'package:star_maker/models/song_model.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/zego_sdk_manager.dart';
import 'package:star_maker/views/solo_singing/solo_singing.dart';
import 'package:star_maker/widgets/live_room_widgets/song_card.dart';
import 'package:star_maker/widgets/solo_singing_widgets/solo_singing_card.dart';

class SoloSingingView extends StatefulWidget {
  const SoloSingingView({super.key});

  @override
  State<SoloSingingView> createState() => _SoloSingingViewState();
}

class _SoloSingingViewState extends State<SoloSingingView> {
  List<Song> songs = [];
  List<RoomModel> rooms = [];
  final roomIDController =
      TextEditingController(text: Random().nextInt(9999999).toString());

  getSongs() async {
    var songApi = SongApi();
    songs = await songApi.getAllSongs();
    setState(() {});
  }

  getRooms() async {
    var roomApi = RoomApi();
    rooms = await roomApi.getSoloRooms();
    setState(() {});
  }

  @override
  void initState() {
    getRooms();
    getSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            'Star Maker',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.deepPurple, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 3.0,
                  color: Colors.grey[400]!,
                ),
              ],
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.deepPurple[100]!,
            labelColor: Colors.deepPurple[400]!,
            tabs: [
              Tab(
                child: Text(
                  'Solo Singers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Songs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  mainAxisExtent: 170,
                ),
                itemCount: rooms.length,
                itemBuilder: (BuildContext context, int index) {
                  RoomModel room = rooms[index];
                  return SoloSingingCard(
                    name: room.hostName,
                    audience: room.audienceCount.toString(),
                    image: "https://robohash.org/${room.hostId}.png?set=set4",
                    onLiveRoomTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SoloSingView(
                                  userID: ZEGOSDKManager().currentUser!.userID,
                                  roomID: room.roomId!,
                                  isHost: false,
                                  song: room.song!,
                                )),
                      );
                    },
                  );
                },
              ),
            ),
            ListView.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                Song song = songs[index];
                return SongCard(
                  image: song.thumbnail_image_url,
                  songName: song.name,
                  singerName: 'Shubh',
                  onSongTap: () async {
                    String roomId = Random().nextInt(9999999).toString();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SoloSingView(
                                userID: ZEGOSDKManager().currentUser!.userID,
                                roomID: roomId,
                                isHost: true,
                                song: song,
                              )),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
