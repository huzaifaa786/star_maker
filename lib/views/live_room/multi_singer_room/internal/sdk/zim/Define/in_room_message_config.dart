import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/message/message_view_item.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/message/defines.dart';
import 'package:zego_uikit/zego_uikit.dart' as zego_uikit;

/// Control options for the bottom-left message list.
/// This class is used for the [inRoomMessageConfig] property of [ZegoUIKitPrebuiltLiveAudioRoomConfig].
///
/// If you want to customize chat messages, you can specify the [itemBuilder] in [ZegoInRoomMessageConfig].
///
/// Example:
///
/// ZegoInRoomMessageViewConfig(
///   itemBuilder: (BuildContext context, ZegoRoomMessage message) {
///     return ListTile(
///       title: Text(message.message),
///       subtitle: Text(message.user.id),
///     );
///   },
/// );
class ZegoInRoomMessageConfig {
  /// Triggered when has click on the message item
  ZegoInRoomMessageViewItemPressEvent? onMessageClick;

  /// Triggered when a pointer has remained in contact with the message item at
  /// the same location for a long period of time.
  ZegoInRoomMessageViewItemPressEvent? onMessageLongPress;

  /// Use this to customize the style and content of each chat message list item.
  /// For example, you can modify the background color, opacity, border radius, or add additional information like the sender's level or role.
  ZegoInRoomMessageItemBuilder? itemBuilder;

  /// background
  Widget? background;

  /// If set to `false`, the message list will be hidden. The default value is `true`.
  bool visible;

  /// The width of chat message list view
  double? width;

  /// The height of chat message list view
  double? height;

  /// The offset of chat message list view bottom-left position
  Offset? bottomLeft;

  /// display user name in message list view or not
  bool showName;

  /// display user avatar in message list view or not
  bool showAvatar;

  /// The opacity of the background color for chat message list items, default value of 0.5.
  /// If you set the [backgroundColor], the [opacity] setting will be overridden.
  double opacity;

  /// The background of chat message list items
  /// If you set the [backgroundColor], the [opacity] setting will be overridden.
  /// You can use `backgroundColor.withOpacity(0.5)` to set the opacity of the background color.
  Color? backgroundColor;

  /// The max lines of chat message list items, default value is not limit.
  int? maxLines;

  /// The name text style of chat message list items
  TextStyle? nameTextStyle;

  /// The message text style of chat message list items
  TextStyle? messageTextStyle;

  /// The border radius of chat message list items
  BorderRadiusGeometry? borderRadius;

  /// The paddings of chat message list items
  EdgeInsetsGeometry? paddings;

  /// resend button icon
  Widget? resendIcon;

  ZegoInRoomMessageConfig({
    this.visible = true,
    this.width,
    this.height,
    this.bottomLeft,
    this.opacity = 0.5,
    this.maxLines,
    this.nameTextStyle,
    this.messageTextStyle,
    this.backgroundColor,
    this.borderRadius,
    this.paddings,
    this.resendIcon,
    this.background,
    this.itemBuilder,
    this.onMessageClick,
    this.onMessageLongPress,
    this.showName = true,
    this.showAvatar = true,
  });
}

@Deprecated('Since 2.8.5, please use ZegoInRoomMessageConfig instead')
typedef ZegoInRoomMessageViewConfig = ZegoInRoomMessageConfig;

class ZegoLiveAudioRoomSeatConfig {
  /// Whether to display a wave indicator around the avatar.

  /// Use this to customize the avatar, and replace the default avatar with it.
  ///
  /// Example：
  ///
  /// ```dart
  ///
  ///  // eg:
  ///  avatarBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
  ///    return user != null
  ///        ? Container(
  ///            decoration: BoxDecoration(
  ///              shape: BoxShape.circle,
  ///              image: DecorationImage(
  ///                image: NetworkImage(
  ///                  'https://your_server/app/avatar/${user.id}.png',
  ///                ),
  ///              ),
  ///            ),
  ///          )
  ///        : const SizedBox();
  ///  },
  ///
  /// ```
  ///
  zego_uikit.ZegoAvatarBuilder? avatarBuilder;

  ZegoLiveAudioRoomSeatConfig({
    this.avatarBuilder,
  });
}
