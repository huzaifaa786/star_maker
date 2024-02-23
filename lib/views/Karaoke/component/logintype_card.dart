import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gap/gap.dart';
import 'package:star_maker/utils/colors.dart';

class googlelogincard extends StatelessWidget {
  const googlelogincard({
    Key? key,
    this.icon,
    this.ontap,
    this.title,
  }) : super(key: key);
  final icon;
  final ontap;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.90,
          decoration: BoxDecoration(
              color: white,
              // border:
              //     Border.all(width: 1, color: lightGreenColor.withOpacity(0.3)),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   icon,
              //   fit: BoxFit.none,
                
              // ),
              Image.asset(
              icon,
              scale: 1.0,
            ),
              Gap(5),
              Text(
                title!,
                style: TextStyle(
                  color: blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )),
    );
  }
}
