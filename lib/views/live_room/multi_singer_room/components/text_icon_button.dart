// Flutter imports:
import 'package:flutter/material.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/input_icon.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/zego_icon_button.dart';

// Package imports:
// import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
// import 'package:zego_uikit_prebuilt_live_audio_room/src/components/defines.dart';
// import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/input_board.dart';
// import 'package:zego_uikit_prebuilt_live_audio_room/src/inner_text.dart';

/// @nodoc
class ZegoInRoomMessageInputBoardButton extends StatefulWidget {
  final Size? iconSize;
  final Size? buttonSize;
  final TextEditingController? textEditingController;
  final onTap;

  final bool rootNavigator;

  final Function(int)? onSheetPopUp;
  final Function(int)? onSheetPop;

  const ZegoInRoomMessageInputBoardButton({
    Key? key,
    this.rootNavigator = false,
    this.iconSize,
    this.buttonSize,
    this.onSheetPopUp,
    this.onSheetPop,
    this.textEditingController,
    this.onTap,
  }) : super(key: key);

  @override
  State<ZegoInRoomMessageInputBoardButton> createState() =>
      _ZegoInRoomMessageInputBoardButtonState();
}

/// @nodoc
class _ZegoInRoomMessageInputBoardButtonState
    extends State<ZegoInRoomMessageInputBoardButton> {
  @override
  Widget build(BuildContext context) {
    return ZegoTextIconButton(
      onPressed: () {
        final key = DateTime.now().millisecondsSinceEpoch;
        widget.onSheetPopUp?.call(key);

        Navigator.of(
          context,
          rootNavigator: widget.rootNavigator,
        )
            .push(
          ZegoInRoomMessageInputBoard(
            textController: widget.textEditingController,
            onTap: widget.onTap,
            rootNavigator: widget.rootNavigator,
          ),
        )
            .then((value) {
          widget.onSheetPop?.call(key);
        });
      },
      icon: const Icon(
        Icons.chat_outlined,
        color: Colors.white,
      ),
      iconSize: widget.iconSize ?? Size(32, 32),
      buttonSize: widget.buttonSize ?? Size(46, 46),
    );
  }
}
