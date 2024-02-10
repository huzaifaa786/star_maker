// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_maker/views/live_room/multi_singer_room/components/zego_icon_button.dart';

/// @nodoc
class ZegoInRoomMessageInput extends StatefulWidget {
  const ZegoInRoomMessageInput({
    Key? key,
    this.placeHolder = 'Say something...',
    this.payloadAttributes,
    this.backgroundColor,
    this.inputBackgroundColor,
    this.textColor,
    this.textHintColor,
    this.cursorColor,
    this.buttonColor,
    this.borderRadius,
    this.enabled = true,
    this.autofocus = true,
    this.onSubmit,
    this.controller,
    this.onTap,
    this.valueNotifier,
    this.focusNotifier,
  }) : super(key: key);

  final String placeHolder;
  final Map<String, String>? payloadAttributes;
  final Color? backgroundColor;
  final Color? inputBackgroundColor;
  final Color? textColor;
  final Color? textHintColor;
  final Color? cursorColor;
  final Color? buttonColor;
  final double? borderRadius;
  final bool enabled;
  final bool autofocus;
  final VoidCallback? onSubmit;
  final ValueNotifier<String>? valueNotifier;
  final ValueNotifier<bool>? focusNotifier;
  final onTap;
  final TextEditingController? controller;

  @override
  State<ZegoInRoomMessageInput> createState() => _ZegoInRoomMessageInputState();
}

/// @nodoc
class _ZegoInRoomMessageInputState extends State<ZegoInRoomMessageInput> {
  // final TextEditingController textController = TextEditingController();
  ValueNotifier<bool> isEmptyNotifier = ValueNotifier(true);
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);

    if (widget.valueNotifier != null) {
      widget.controller!.text = widget.valueNotifier!.value;

      isEmptyNotifier.value = widget.controller!.text.isEmpty;
    }
  }

  @override
  void dispose() {
    super.dispose();

    focusNode
      ..removeListener(onFocusChange)
      ..dispose();
  }

  void onFocusChange() {
    widget.focusNotifier?.value = focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: widget.backgroundColor ?? const Color(0xff222222).withOpacity(0.8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            messageInput(),
            SizedBox(width: 10),
            sendButton(),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget messageInput() {
    final messageSendBgColor = widget.buttonColor ?? const Color(0xff3e3e3d);
    final messageSendCursorColor =
        widget.cursorColor ?? const Color(0xffA653ff);
    final messageSendHintStyle = TextStyle(
      color: widget.textHintColor ?? const Color(0xffa4a4a4),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    final messageSendInputStyle = TextStyle(
      color: widget.textColor ?? Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );

    return Expanded(
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: widget.inputBackgroundColor ?? messageSendBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          enabled: widget.enabled,
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: null,
          autofocus: widget.autofocus,
          focusNode: focusNode,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(400)
          ],
          controller: widget.controller,
          onChanged: (String inputMessage) {
            widget.valueNotifier?.value = inputMessage;

            final valueIsEmpty = inputMessage.isEmpty;
            if (valueIsEmpty != isEmptyNotifier.value) {
              isEmptyNotifier.value = valueIsEmpty;
            }
          },
          textInputAction: TextInputAction.send,
          onSubmitted: (message) => widget.onTap,
          cursorColor: messageSendCursorColor,
          cursorHeight: 20,
          cursorWidth: 3,
          style: messageSendInputStyle,
          decoration: InputDecoration(
            hintText: widget.placeHolder,
            hintStyle: messageSendHintStyle,
            contentPadding: EdgeInsets.only(
              left: 20,
              top: 5,
              right: 20,
              bottom: 15,
            ),
            // isDense: true,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isEmptyNotifier,
      builder: (context, bool isEmpty, Widget? child) {
        return ZegoTextIconButton(
          onPressed: () {
            if (!isEmpty) {
              widget.onTap;
              widget.valueNotifier?.value = '';

              widget.onSubmit?.call();
            }
          },
          icon: isEmpty
              ? Image.asset(
                  'assets/icons/send_disable.png',
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                )
              : Image.asset(
                  'assets/icons/send_disable.png',
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                ),
          iconSize: Size(50, 50),
          buttonSize: Size(50, 50),
        );
      },
    );
  }
}
