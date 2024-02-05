import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:star_maker/routes/routes.dart';
import 'package:star_maker/widgets/buttons/main_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Star Maker',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [Colors.deepPurple, Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            shadows: <Shadow>[
              Shadow(
                offset: const Offset(4.0, 4.0),
                blurRadius: 3.0,
                color: Colors.grey[400]!,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg_white_logo.jpeg'))),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
