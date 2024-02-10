// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:star_maker/apis/song_api.dart';
import 'package:star_maker/models/song_model.dart';
import 'package:star_maker/views/live_room/multi_singer_room/multi_singer.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/business/business_define.dart';
import 'package:star_maker/views/solo_singing/solo_singing.dart';
import 'package:star_maker/widgets/live_room_widgets/live_room_card.dart';
import 'package:star_maker/widgets/live_room_widgets/song_card.dart';

class LiveRoomsView extends StatefulWidget {
  const LiveRoomsView({super.key});

  @override
  State<LiveRoomsView> createState() => _LiveRoomsViewState();
}

class _LiveRoomsViewState extends State<LiveRoomsView> {
  List<Song> songs = [];
  final roomIDController =
      TextEditingController(text: Random().nextInt(9999999).toString());

  getSongs() async {
    var songApi = SongApi();
    songs = await songApi.getAllSongs();
    setState(() {});
  }

  @override
  void initState() {
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
              fontSize: 28,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Colors.deepPurple, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.deepPurple[800]!,
            labelColor: Colors.deepPurple[800]!,
            tabs: [
              Tab(
                child: Text(
                  'Live Rooms',
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
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return LiveRoomCard(
                    name: 'Abdur Rehman',
                    audience: '999',
                    image: "https://robohash.org/" +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        ".png",
                    onLiveRoomTap: () {},
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiSingersKaraoke(
                                roomID: roomIDController.text,
                                role: ZegoLiveAudioRoomRole.host,
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
