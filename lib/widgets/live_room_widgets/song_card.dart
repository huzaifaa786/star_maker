// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/gradient_borders.dart';

class SongCard extends StatelessWidget {
  const SongCard(
      {super.key, this.image, this.singerName, this.songName, this.onSongTap});
  final String? image;
  final String? singerName;
  final String? songName;
  final onSongTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            margin: const EdgeInsets.only(right: 12, left: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.red],
                  ),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: image!,
                          placeholder: (context, url) =>
                              const Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$songName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Colors.deepPurple, Colors.pinkAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        // Text(
                        //   'By $singerName',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 14
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: onSongTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple[300],
                        borderRadius: BorderRadius.circular(45)),
                    child: const Icon(
                      CupertinoIcons.play,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
