import 'package:flutter/material.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:gap/gap.dart';

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
                            Text('Add Profile Picture',style: TextStyle(color: blueAccent,fontSize: 15,fontWeight:FontWeight.w400),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/user.png',
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
