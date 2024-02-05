import 'package:flutter/material.dart';
import 'package:star_maker/views/home/home_view.dart';
import 'package:star_maker/views/live_room/live_room_view.dart';
import 'package:star_maker/views/solo_singing/solo_singing_view.dart';
import 'package:star_maker/views/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Maker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
