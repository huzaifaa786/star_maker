import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_maker/views/live_room/multi_singer_room/internal/live_audio_room_manager.dart';

import '../../internal/sdk/express/express_service.dart';

class ZegoSeatItemView extends StatelessWidget {
  const ZegoSeatItemView(
      {super.key, required this.onPressed, required this.seatIndex});
  final int seatIndex;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ZegoSDKUser?>(
      valueListenable:
          ZegoLiveAudioRoomManager().seatList[seatIndex].currentUser,
      builder: (context, user, _) {
        if (user != null) {
          return userSeatView(user, seatIndex);
        } else {
          return emptySeatView();
        }
      },
    );
  }

  Widget userSeatView(ZegoSDKUser userInfo, int seatIndex) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          userAvatar(userInfo, seatIndex),
          const SizedBox(height: 5),
          Text(
            userInfo.userName,
            style: const TextStyle(color: Colors.white, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget userAvatar(ZegoSDKUser userInfo, int seatIndex) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ValueListenableBuilder<String?>(
        valueListenable: userInfo.avatarUrlNotifier,
        builder: (context, avatarUrl, child) {
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    color: seatIndex == 0 ? Colors.amber : Colors.blue,
                    width: 3.0),
                borderRadius: BorderRadius.circular(40)),
            child: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, _) =>
                        const CupertinoActivityIndicator(color: Colors.white),
                    errorWidget: (context, url, error) => child!,
                  )
                : child,
          );
        },
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.grey, border: Border(bottom: BorderSide.none)),
          child: Center(
            child: SizedBox(
              height: 24,
              child: Text(
                userInfo.userID.substring(0, 1),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emptySeatView() {
    return ValueListenableBuilder<bool>(
        valueListenable: ZegoLiveAudioRoomManager().isLockSeat,
        builder: (context, isLock, _) {
          return GestureDetector(
            onTap: isLock ? null : onPressed,
            child: Column(children: [
              SizedBox(
                width: 60,
                height: 60,
                child: isLock
                    ? Image.asset('assets/icons/seat_lock_icon.png',
                        fit: BoxFit.fill)
                    : Image.asset('assets/icons/seat_icon_normal.png',
                        fit: BoxFit.fill),
              ),
              const Text(''),
            ]),
          );
        });
  }
}
