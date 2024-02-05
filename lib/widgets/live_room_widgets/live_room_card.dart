// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LiveRoomCard extends StatelessWidget {
  const LiveRoomCard(
      {super.key, this.name, this.audience, this.image, this.onLiveRoomTap});
  final String? name;
  final String? audience;
  final String? image;
  final onLiveRoomTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onLiveRoomTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/live_card.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.music_house,
                          size: 12, color: Colors.pink[300]),
                      const Gap(4),
                      Text(
                        'Live Room',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.pink[300],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    '$name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.8),
                      shadows: <Shadow>[
                        Shadow(
                          offset: const Offset(2, 3.0),
                          blurRadius: 2.0,
                          color: Colors.grey[400]!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: image!,
                      placeholder: (context, url) =>
                          const Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(CupertinoIcons.person,
                        size: 14, color: Colors.deepPurple[300]),
                    const Gap(2),
                    Text(
                      '$audience',
                      style:
                          TextStyle(fontSize: 12, color: Colors.deepPurple[300]),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
