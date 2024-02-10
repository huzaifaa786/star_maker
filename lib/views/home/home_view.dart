import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:star_maker/routes/routes.dart';
import 'package:star_maker/widgets/buttons/main_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(150),
              GradientText(
                'Star Maker',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 45,
                ),
                colors: [Colors.deepPurple, Colors.pinkAccent],
              ),
              Gap(150),
              MainButton(
                title: 'Create/Join Live Room',
                onButtonTap: () {
                  AppRoutes.navigateToJoinOrCreateLiveRoom(context);
                },
                icon: CupertinoIcons.music_house,
              ),
              const Gap(20),
              MainButton(
                title: 'Solo Singing',
                onButtonTap: () {
                  AppRoutes.navigateToSoloSinging(context);
                },
                icon: CupertinoIcons.music_mic,
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}
