import 'dart:async';
import 'dart:math';

// import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:star_maker/utils/zegocloud_token.dart';
import 'package:star_maker/views/live_room/multi_singer_room/entry_audio_room.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/express/express_service.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/zim/zim_service.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/zego_sdk_key_center.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/zego_sdk_manager.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<StreamSubscription> subscriptions = [];
  final userIDController =
      TextEditingController(text: Random().nextInt(100000).toString());
  final userNameController = TextEditingController(
      text: Random().nextInt(100000).toString() + "_user");

  @override
  void initState() {
    super.initState();
    subscriptions.addAll([
      ZEGOSDKManager()
          .zimService
          .connectionStateStreamCtrl
          .stream
          .listen((ZIMServiceConnectionStateChangedEvent event) {
        debugPrint('connectionStateStreamCtrl: $event');
        if (event.state == ZIMConnectionState.connected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AudioRoomEntry()),
          );
        }
      })
    ]);
  }

  @override
  void dispose() {
    for (final element in subscriptions) {
      element.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            userIDInputView(),
            const SizedBox(height: 20),
            userNameInputView(),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                 
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userIDInputView() {
    return Row(
      children: [
        const SizedBox(width: 20),
        const Text('userID:'),
        const SizedBox(width: 10),
        Flexible(
            child: TextField(
          controller: userIDController,
          decoration: const InputDecoration(
            labelText: 'please input your userID',
          ),
        )),
      ],
    );
  }

  Widget userNameInputView() {
    return Row(
      children: [
        const SizedBox(width: 20),
        const Text('userName:'),
        const SizedBox(width: 10),
        Flexible(
            child: TextField(
          controller: userNameController,
          decoration: const InputDecoration(
            labelText: 'please input your userName',
          ),
        )),
      ],
    );
  }
}
