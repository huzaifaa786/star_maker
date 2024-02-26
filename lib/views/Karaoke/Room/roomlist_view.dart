// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({super.key});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [Image.asset('assets/images/Back Arrow.png')],
              ),
              Gap(7),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientTextStatic('Rooms',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                        colors: [Colors.purpleAccent, Colors.blue]),
                    Image.asset('assets/images/Search.png'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 81, 100, 209),
                ),
              ),
              //button row
              Row(
                children: [],
              ),
              //2nd divider
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 81, 100, 209),
                ),
              ),
              //2nd heading
              Text(
                'Public Rooms',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              )
            ],
          ),
        ),
      )),
    );
  }
}
