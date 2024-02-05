// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:star_maker/widgets/live_room_widgets/song_card.dart';
import 'package:star_maker/widgets/solo_singing_widgets/solo_singing_card.dart';

class SoloSingingView extends StatefulWidget {
  const SoloSingingView({super.key});

  @override
  State<SoloSingingView> createState() => _SoloSingingViewState();
}

class _SoloSingingViewState extends State<SoloSingingView> {
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
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return SoloSingingCard(
                    name: 'Abdur Rehman',
                    audience: '999',
                    image: "http://via.placeholder.com/75x75",
                    onLiveRoomTap: () {},
                  );
                },
              ),
            ),
            SongCard(
              image: "http://via.placeholder.com/75x75",
              songName: 'King Shit',
              singerName: 'Shubh',
              onSongTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
