import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/enums/message_type.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/widget/image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMyMessage;
  const MessageWidget({super.key,required this.message,required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        message.messageType==MessageType.text
            ?messageTypeText(context)
            :messageTypeImage(context)
      ],
    );
  }

  Widget messageTypeText(BuildContext context){
    return Flexible(
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width-80
        ),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMyMessage ? AppColors.myMessageColor.withOpacity(0.5) : AppColors.friendMessageColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),bottomLeft:Radius.circular(15),topRight: Radius.circular(15)),
        ),
        child: Text(
          message.messageContent!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget messageTypeImage(BuildContext context){
    return GestureDetector(
      onTap: (){
        Get.to(()=>ImageScreen(path: message.path!));
      },
      child: Container(
        width: 200,height: 300,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
              color:isMyMessage ? AppColors.myMessageColor : AppColors.friendMessageColor,
              width: 5,
          ),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),bottomLeft:Radius.circular(15),topRight: Radius.circular(15)),
          image: DecorationImage(image:message.path!.startsWith('https')
              ?CachedNetworkImageProvider(message.path!)
              :FileImage(File(message.path!))
              ,fit: BoxFit.cover)
        ),
      ),
    );
  }
}
