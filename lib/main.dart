import 'package:flutter/material.dart';

import 'package:star_maker/views/splash/splash_view.dart';

import 'package:zego_uikit/zego_uikit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ZegoUIKit().initLog().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Maker',
      theme: ThemeData(
        fontFamily: 'Proxima Nova',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
