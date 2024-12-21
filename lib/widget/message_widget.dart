import 'package:chat_app/data/models/message.dart';
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
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isMyMessage ? Colors.red.shade100 : Colors.green.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message.messageContent!,
            style: TextStyle(color: isMyMessage ? Colors.red : Colors.green),
          ),
        ),
      ],
    );;
  }
}
