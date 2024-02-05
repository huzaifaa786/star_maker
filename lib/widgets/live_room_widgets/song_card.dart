// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.pink[100]!,
                      offset: const Offset(1, 1),
                      blurRadius: 12),
                  BoxShadow(
                      color: Colors.deepPurple[100]!,
                      offset: const Offset(-1, -1),
                      blurRadius: 12),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.pink[100]!,
                            offset: const Offset(1, 1),
                            blurRadius: 8),
                        BoxShadow(
                            color: Colors.deepPurple[100]!,
                            offset: const Offset(-1, -1),
                            blurRadius: 8),
                      ]),
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
                            fontSize: 16,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.pinkAccent
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(3.0, 4.0),
                                blurRadius: 3.0,
                                color: Colors.grey[400]!,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'By $singerName',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(2, 3.0),
                                blurRadius: 2.0,
                                color: Colors.grey[400]!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                InkWell(
                  onTap: onSongTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(45),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.pink[100]!,
                              offset: const Offset(2, 2),
                              blurRadius: 12),
                          BoxShadow(
                              color: Colors.deepPurple[100]!,
                              offset: const Offset(-2, -2),
                              blurRadius: 12),
                        ]),
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
