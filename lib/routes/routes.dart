import 'package:flutter/material.dart';
import 'package:star_maker/views/auth/login_view.dart';
import 'package:star_maker/views/home/home_view.dart';
import 'package:star_maker/views/karaoke/main/fragment/categorydetail/category_detail.dart';
import 'package:star_maker/views/karaoke/main/mainscreen.dart';
import 'package:star_maker/views/karaoke/singing/signing.dart';
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

  static void navigateToLoginView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  static void navigateToMainView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  }

  static void navigateTocategorydetailView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryDetailView()),
    );
  }

  static void navigateTosigningView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SigningView()),
    );
  }
}
