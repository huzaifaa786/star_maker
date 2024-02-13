import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';

///Sample Netease style
///should be extends LyricUI implementation your own UI.
///this property only for change UI,if not demand just only overwrite methods.
class UILyrics extends LyricUI {
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;
  Color highlightColor;

  UILyrics(
      {this.defaultSize = 18,
      this.defaultExtSize = 14,
      this.otherMainSize = 16,
      this.bias = 0.5,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlight = true,
      this.highlightColor = Colors.amber,
      this.highlightDirection = HighlightDirection.LTR});

  UILyrics.clone(UILyrics UILyrics)
      : this(
          defaultSize: UILyrics.defaultSize,
          defaultExtSize: UILyrics.defaultExtSize,
          otherMainSize: UILyrics.otherMainSize,
          bias: UILyrics.bias,
          lineGap: UILyrics.lineGap,
          inlineGap: UILyrics.inlineGap,
          lyricAlign: UILyrics.lyricAlign,
          lyricBaseLine: UILyrics.lyricBaseLine,
          highlight: UILyrics.highlight,
          highlightDirection: UILyrics.highlightDirection,
          highlightColor: UILyrics.highlightColor,
        );

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.grey[300], fontSize: defaultExtSize);

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.grey[300],
        fontSize: defaultExtSize,
      );

  @override
  TextStyle getOtherMainTextStyle() =>
      TextStyle(color: Colors.grey[200], fontSize: otherMainSize);

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
        color: Colors.white,
        fontSize: defaultSize,
      );

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;

  @override
  Color getLyricHightlightColor() => highlightColor;
}
