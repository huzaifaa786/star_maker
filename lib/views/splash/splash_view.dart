// ignore_for_file: use_full_hex_values_for_flutter_colors
import 'package:flutter/material.dart';
import 'package:star_maker/routes/routes.dart';
// import 'package:is_first_run/is_first_run.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  void initscreen() async {
    await Future.delayed(const Duration(seconds: 3), () {
      checkFirstSeen();
      setState(() {});
    });
  }

  Future checkFirstSeen() async {
    // bool firstCall = await IsFirstRun.isFirstCall();
    // if (firstCall) {
    AppRoutes.navigateToHomeView(context);
    // } else {
    // final User? user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   Get.offNamed(AppRoutes.footer);
    // } else {
    //   Get.offNamed(AppRoutes.signin);
    // }
    // }
  }

  @override
  void initState() {
    initscreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       Color(4289491966),
        //       Color(4289491966),
        //       Color(4289494015),
        //       Color(4289494015),
        //       Color(4289494015),
        //       Color(4289505535),
        //       Color(4288538110),
        //       Color(4292214271)
        //     ],
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bg_white_logo.jpeg',
              height: 210,
              width: 210,
            ),
          ],
        ),
      ),
    );
  }
}
