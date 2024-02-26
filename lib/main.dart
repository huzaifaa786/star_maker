import 'package:flutter/material.dart';
import 'package:star_maker/views/Karaoke/profile/profile_view.dart';
import 'package:star_maker/views/auth/signup_view.dart';
import 'package:star_maker/views/onboarding/onboarding.dart';

import 'package:star_maker/views/splash/splash_view.dart';

import 'package:zego_uikit/zego_uikit.dart';
 import 'dart:io';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ZegoUIKit().initLog().then((value) {
     HttpOverrides.global = MyHttpOverrides();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Star Maker',
      theme: ThemeData(
        fontFamily: 'Proxima Nova',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProfileView(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}