// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class RoomListContainer extends StatelessWidget {
  const RoomListContainer(
      {super.key,
      this.headingname,
      this.subheading,
      this.ontap,
      this.backimg,
      this.imgfirst,
      this.imgsecond,
      this.imgthird});
  final headingname;
  final subheading;
  final ontap;
  final backimg;
  final imgfirst;
  final imgsecond;
  final imgthird;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        // decoration: BoxDecoration(border: Border.all()),
        child: Column(
          children: [
            Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: 53,
                        width: 57,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(backimg),
                              ),
                              Positioned(
                                  right: 7,
                                  bottom: -7,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(imgfirst),
                                    ),
                                  )),
                              Positioned(
                                  right: -7,
                                  bottom: 1,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(imgsecond),
                                    ),
                                  )),
                              Positioned(
                                  right: -9,
                                  bottom: 15,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(imgthird),
                                    ),
                                  )),
                            ],
                          ),
                        )),
                    Gap(14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(7),
                        GradientTextStatic(
                          headingname,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                          colors: [Colors.purpleAccent, Colors.blue],
                        ),
                        GradientTextStatic(
                          subheading,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700),
                          colors: [
                            Color.fromARGB(255, 215, 140, 228),
                            Color.fromARGB(255, 114, 181, 235)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    height: 20,
                    width: 54,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 215, 140, 228),
                            Color.fromARGB(255, 114, 156, 235)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                    child: Center(
                      child: GradientTextStatic('Join',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w800),
                          colors: [Colors.grey.shade50, Colors.white]),
                    ),
                  ),
                ),
              ],
            ),
            Gap(20),
            Container(
              height: 1,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 215, 140, 228),
                  Color.fromARGB(255, 114, 156, 235)
                ],
              )),
            ),
            Gap(8),
          ],
        ),
      ),
    );
  }
}
