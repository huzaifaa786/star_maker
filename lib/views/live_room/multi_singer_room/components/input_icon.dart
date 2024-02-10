// Flutter imports:
import 'package:flutter/material.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/message/message.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/message_input.dart';

// Package imports:
// import 'package:zego_uikit/zego_uikit.dart';

// Project imports
// import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// @nodoc
class ZegoInRoomMessageInputBoard extends ModalRoute<String> {
  ZegoInRoomMessageInputBoard({
    this.rootNavigator = false,
    this.textController,
    this.onTap,
  }) : super();

  final bool rootNavigator;
  final TextEditingController? textController;
  final onTap;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Color(0xff171821).withOpacity(0.4);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(
                context,
                rootNavigator: rootNavigator,
              ).pop(),
              child: Container(color: Colors.transparent),
            ),
          ),
          ZegoInRoomMessageInput(
            controller: textController,
            onTap: onTap,
            placeHolder: 'Send message',
            backgroundColor: Colors.white,
            inputBackgroundColor: const Color(0xffF7F7F8),
            textColor: const Color(0xff1B1B1B),
            textHintColor: const Color(0xff1B1B1B).withOpacity(0.5),
            buttonColor: const Color(0xff0055FF),
            onSubmit: () {
              Navigator.of(
                context,
                rootNavigator: rootNavigator,
              ).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
