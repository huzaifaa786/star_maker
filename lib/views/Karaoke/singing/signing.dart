// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
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
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(4291526907), Color(4287208699)])),
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
                Gap(10),
                Container( width: MediaQuery.of(context).size.width ,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(4292789245), Color(4291022845)])),
                  child: Column(
                    children: [
                      Text('data')
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
