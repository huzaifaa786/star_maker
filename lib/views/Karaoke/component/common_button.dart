// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key, this.name, this.picture, this.size, this.width});

  final name;
  final picture;
  final size;
  final width;

  @override
  Widget build(BuildContext context) {
    return Card(
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
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              colors: [
                Colors.purpleAccent,
                Colors.blue,
              ],
            ),
            Gap(25),
          ],
        ),
      ),
    );
  }
}
