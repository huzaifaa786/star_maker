import 'package:flutter/material.dart';
import 'package:star_maker/utils/colors.dart';
import 'package:star_maker/views/Karaoke/component/logintype_card.dart';
import 'package:gap/gap.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, right: 15, left: 15),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Star Maker',
                    style: TextStyle(
                        color: white,
                        fontSize: 35,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              Gap(150),
              googlelogincard(
                icon: 'assets/images/Apple Logo.png',
                title: 'Sign in with Apple Id',
                ontap: () {},
              ),
              Gap(20),
              googlelogincard(
                icon: 'assets/images/Apple Logo.png',
                title: 'Sign in with Apple Id',
                ontap: () {},
              ),
              Gap(20),
              googlelogincard(
                icon: 'assets/images/Apple Logo.png',
                title: 'Sign in with Apple Id',
                ontap: () {},
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account Log In',
                    style: TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,decoration: TextDecoration.underline,),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
