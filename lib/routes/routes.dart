import 'package:flutter/material.dart';
import 'package:star_maker/views/home/home_view.dart';
import 'package:star_maker/views/live_room/live_room_view.dart';
import 'package:star_maker/views/solo_singing/solo_singing_view.dart';

class AppRoutes {
  static void navigateToHomeView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  }

  static void navigateToJoinOrCreateLiveRoom(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LiveRoomsView()),
    );
  }

  static void navigateToSoloSinging(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SoloSingingView()),
    );
  }
}
