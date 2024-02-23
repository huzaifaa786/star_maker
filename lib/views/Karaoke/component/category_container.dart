// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({super.key, this.name, this.pic, this.ontap});
  final name;
  final pic;
  final ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: ontap,
      child: Column(
        children: [
          Container(
            height: 175,
            width: 170,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Image.asset(
              pic,
              fit: BoxFit.fill,
            ),
          ),
          Gap(5),
          GradientTextStatic(name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              colors: [Colors.purpleAccent, Colors.blue]),
        ],
      ),
    );
    
  }
}
