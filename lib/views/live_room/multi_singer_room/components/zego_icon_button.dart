// Flutter imports:
import 'package:flutter/material.dart';

class ZegoTextIconButton extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final bool? softWrap;

  final Widget? icon;
  final Size? iconSize;
  final double? iconTextSpacing;
  final Color? iconBorderColor;

  final Size? buttonSize;
  final double? borderRadius;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;
  final Color? clickableTextColor;
  final Color? unclickableTextColor;
  final Color? clickableBackgroundColor;
  final Color? unclickableBackgroundColor;

  final bool verticalLayout;

  const ZegoTextIconButton({
    Key? key,
    this.text,
    this.textStyle,
    this.softWrap,
    this.icon,
    this.iconTextSpacing,
    this.iconSize,
    this.iconBorderColor,
    this.buttonSize,
    this.borderRadius,
    this.margin,
    this.padding,
    this.onPressed,
    this.clickableTextColor = Colors.black,
    this.unclickableTextColor = Colors.black,
    this.clickableBackgroundColor = Colors.transparent,
    this.unclickableBackgroundColor = Colors.transparent,
    this.verticalLayout = true,
  }) : super(key: key);

  @override
  State<ZegoTextIconButton> createState() => _ZegoTextIconButtonState();
}

/// @nodoc
class _ZegoTextIconButtonState extends State<ZegoTextIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onPressed,
      child: Container(
        width: widget.buttonSize?.width ?? 120,
        height: widget.buttonSize?.height ?? 120,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.onPressed != null
              ? widget.clickableBackgroundColor
              : widget.unclickableBackgroundColor,
          borderRadius: null != widget.borderRadius
              ? BorderRadius.all(Radius.circular(widget.borderRadius!))
              : null,
          shape: null != widget.borderRadius
              ? BoxShape.rectangle
              : BoxShape.circle,
        ),
        child: widget.verticalLayout
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children(context),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children(context),
              ),
      ),
    );
  }

  List<Widget> children(BuildContext context) {
    return [
      icon(),
      ...text(),
    ];
  }

  Widget icon() {
    if (widget.icon == null) {
      return Container();
    }

    return Container(
      width: widget.iconSize?.width ?? 74,
      height: widget.iconSize?.height ?? 74,
      decoration: BoxDecoration(
        color:  Colors.transparent,
        border: Border.all(
            color: widget.iconBorderColor ?? Colors.transparent, width: 1),
        borderRadius:
            BorderRadius.all(Radius.circular(widget.iconSize?.width ?? 74 / 2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.iconSize?.width ?? 74 / 2),
        child: widget.icon,
      ),
    );
  }

  List<Widget> text() {
    if (widget.text == null || widget.text!.isEmpty) {
      return [Container()];
    }

    final iconTextSpacing =
        (widget.icon == null ? 0.0 : widget.iconTextSpacing) ?? 12.0;
    return [
      if (widget.verticalLayout)
        SizedBox(height: iconTextSpacing)
      else
        SizedBox(width: iconTextSpacing),
      Text(
        widget.text!,
        softWrap: widget.softWrap,
        style: widget.textStyle ??
            TextStyle(
              color: widget.onPressed != null
                  ? widget.clickableTextColor
                  : widget.unclickableTextColor,
              fontSize: 26,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
      ),
    ];
  }

  void onPressed() {
    widget.onPressed?.call();
  }
}
