// Flutter imports:
import 'package:flutter/material.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/sdk/zim/Define/in_room_message_config.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:

/// @nodoc
class ZegoInRoomLiveMessageView extends StatefulWidget {
  final ZegoInRoomMessageConfig? config;
  final ZegoAvatarBuilder? avatarBuilder;

  const ZegoInRoomLiveMessageView({
    Key? key,
    this.config,
    this.avatarBuilder,
  }) : super(key: key);

  @override
  State<ZegoInRoomLiveMessageView> createState() =>
      _ZegoInRoomLiveMessageViewState();
}

/// @nodoc
class _ZegoInRoomLiveMessageViewState extends State<ZegoInRoomLiveMessageView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: widget.config?.background ?? Container(),
          ),
          ZegoInRoomMessageView(
            historyMessages: ZegoUIKit().getInRoomMessages(),
            stream: ZegoUIKit().getInRoomMessageListStream(),
            itemBuilder: widget.config?.itemBuilder ??
                (BuildContext context, ZegoInRoomMessage message, _) {
                  return ZegoInRoomMessageViewItem(
                    message: message,
                    avatarBuilder: widget.avatarBuilder,
                    showName: widget.config?.showName ?? true,
                    showAvatar: widget.config?.showAvatar ?? true,
                    resendIcon: widget.config?.resendIcon,
                    borderRadius: widget.config?.borderRadius,
                    paddings: widget.config?.paddings,
                    opacity: widget.config?.opacity,
                    backgroundColor: widget.config?.backgroundColor,
                    maxLines: widget.config?.maxLines,
                    nameTextStyle: widget.config?.nameTextStyle,
                    messageTextStyle: widget.config?.messageTextStyle,
                    onItemClick: widget.config?.onMessageClick,
                    onItemLongPress: widget.config?.onMessageLongPress,
                  );
                },
          ),
        ],
      ),
    );
  }
}
