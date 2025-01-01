import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMyMessage;
  const MessageWidget({super.key,required this.message,required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width-80
            ),
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMyMessage ? AppColors.myMessageColor.withOpacity(0.5) : AppColors.friendMessageColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message.messageContent!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
