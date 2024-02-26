// ignore_for_file: prefer_final_fields, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_import

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:star_maker/views/Karaoke/Room/roomlist_view.dart';
import 'package:star_maker/views/auth/login_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:star_maker/views/karaoke/component/karaoke_component.dart';
import 'package:star_maker/views/karaoke/main/fragment/categories/category.dart';
import 'package:star_maker/views/solo_singing/solo_singing.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navigationMenuIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _fragments = [
      CategoriesView(),
      RoomListView(),
      LoginView(),
      LoginView(),
    ];
    return Scaffold(
      body: SafeArea(
        child: _fragments[_navigationMenuIndex],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 35,
        surfaceTintColor: white,
        color: white,
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    _navigationMenuIndex = 0;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: white,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Microphone.png',
                            fit: BoxFit.scaleDown,
                            height: 38,
                            width: 38,
                          ),
                          Gap(3),
                          _navigationMenuIndex == 0
                              ? Container(
                                  height: 6,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _navigationMenuIndex = 1;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/SpeechBubble.png',
                          fit: BoxFit.scaleDown,
                          height: 38,
                          width: 38,
                        ),
                        Gap(3),
                        _navigationMenuIndex == 1
                            ? Container(
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _navigationMenuIndex = 2;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: white,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/UserGroups.png',
                            fit: BoxFit.scaleDown,
                            height: 38,
                            width: 38,
                          ),
                          Gap(3),
                          _navigationMenuIndex == 2
                              ? Container(
                                  height: 6,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _navigationMenuIndex = 3;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  color: white,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _navigationMenuIndex = 3;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit.scaleDown,
                            height: 38,
                            width: 38,
                          ),
                          Gap(3),
                          _navigationMenuIndex == 3
                              ? Container(
                                  height: 6,
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
