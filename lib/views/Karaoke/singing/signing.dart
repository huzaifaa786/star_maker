// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_maker/utils/colors.dart';

class SigningView extends StatefulWidget {
  const SigningView({super.key});

  @override
  State<SigningView> createState() => _SigningViewState();
}

class _SigningViewState extends State<SigningView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.purpleAccent, Colors.blue])),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/images/cancel.svg'),
                    Column(
                      children: [
                        Text(
                          'Pyramids',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: white.withOpacity(1)),
                        ),
                        Text(
                          'By Frank Ocean',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: white.withOpacity(1)),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.more_vert,
                      color: white.withOpacity(1),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: [
                        const Color.fromARGB(255, 122, 22, 139),
                        Colors.blue
                      ])),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
