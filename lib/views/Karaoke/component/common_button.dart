// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.picture,
    this.name,
  });

  final picture;
  final name;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Image.asset(picture),
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
    );
  }
}
