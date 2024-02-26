// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:star_maker/utils/colors.dart';

class CustomeButton extends StatelessWidget {
  const CustomeButton({
    super.key,
    @required this.title,
    this.buttonWidth=0.45,
    @required this.onPressed,
  });
  final title;
  final buttonWidth;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * buttonWidth,
      height: 40,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(4288824831), Color(4283718655)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
