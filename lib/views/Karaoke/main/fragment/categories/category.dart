// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:star_maker/utils/colors.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      SafeArea(child: 
      SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                GradientText('Categories',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800),colors: [Colors.purple,Colors.blue],),
              ],
            ),
          ],
        ),
      )),
    );
  }
}