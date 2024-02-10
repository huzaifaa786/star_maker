// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainButton extends StatelessWidget {
  const MainButton({super.key, this.onButtonTap, this.title, this.icon});
  final String? title;
  final onButtonTap;
  final icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepPurple[600]!, Colors.red[500]!]),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const Gap(4),
            Text(
              '$title',
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
