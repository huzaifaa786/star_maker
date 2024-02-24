import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/views/karaoke/component/gradient_text.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
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
            colors: [Colors.purple, Colors.blueAccent],
          )),
          child: Column(
            children: [
              Gap(80),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.80,
                    width: MediaQuery.of(context).size.width * 0.90,
                    decoration: BoxDecoration(
                        color: white,
                        // border:
                        //     Border.all(width: 1, color: lightGreenColor.withOpacity(0.3)),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Column(
                      children: [
                        Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientTextStatic('Add Profile Picture',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                                colors: [Colors.purpleAccent, Colors.blue]),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                  Positioned(
                    // bottom: 470,
                    top: -20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/User.png',
                        scale: 1.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
