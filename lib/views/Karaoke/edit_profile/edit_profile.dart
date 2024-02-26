// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Row(
                            children: [
                              Image.asset('assets/images/arrow_back.png'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [lightpinkAccent, lightblueAccent],
                    )),
                  ),

                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    elevation: 10,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Column(
                      children: [
                        Gap(50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientTextStatic(
                              'Edit Profile Picture',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700),
                              colors: [Colors.purpleAccent, Colors.blue],
                            ),
                          ],
                        ),
                        Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  width: 2,
                                  color: lightblueAccent,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFEFD2F4),
                                      Color(0xFFCCE4F7),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Gap(25),
                                    Image.asset('assets/images/Customer.png'),
                                    Gap(10),
                                    GradientTextStatic(
                                      'Edit Profile',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                      colors: [
                                        Colors.purpleAccent,
                                        Colors.blue,
                                      ],
                                    ),
                                    Gap(25),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.49,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0, // Width of the top border
                                    color:
                                        lightblueAccent, // Color of the top border
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0, // Width of the bottom border
                                    color:
                                        lightblueAccent, // Color of the bottom border
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GradientTextStatic(
                                        '15K',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                        colors: [
                                          Colors.purpleAccent,
                                          Colors.blue
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GradientTextStatic(
                                        'Followers',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                        colors: [
                                          Colors.purpleAccent,
                                          Colors.blue
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.49,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 1.0, // Width of the right border
                                    color:
                                        lightblueAccent, // Color of the right border
                                  ),
                                  top: BorderSide(
                                    width: 1.0, // Width of the top border
                                    color:
                                        lightblueAccent, // Color of the top border
                                  ),
                                  bottom: BorderSide(
                                    width: 1.0, // Width of the bottom border
                                    color:
                                        lightblueAccent, // Color of the bottom border
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GradientTextStatic(
                                        '500',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                        colors: [
                                          Colors.purpleAccent,
                                          Colors.blue
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GradientTextStatic(
                                        'Following',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                        colors: [
                                          Colors.purpleAccent,
                                          Colors.blue
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientTextStatic(
                              'Bio',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                              colors: [
                                Colors.purpleAccent,
                                Colors.blue,
                              ],
                            ),
                          ],
                        ),
                        Gap(25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(20),
                            GradientTextStatic(
                              'My Name is Mohammed and I love to sing!',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              colors: [
                                Colors.purpleAccent,
                                Colors.blue,
                              ],
                            ),
                            Gap(20),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(20),
                            GradientTextStatic(
                              'Add me and lets start singing together today!',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                              colors: [
                                Colors.purpleAccent,
                                Colors.blue,
                              ],
                            ),
                            Gap(20),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ],
                    ),
                  ), //Container

                  Positioned(
                    top: 175,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
