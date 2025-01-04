import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/enums/message_type.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/widget/image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMyMessage;
  const MessageWidget(
      {super.key, required this.message, required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        message.messageType == MessageType.text
            ? messageTypeText(context)
            : messageTypeImage(context, isMyMessage)
      ],
    );
  }

  Widget messageTypeText(BuildContext context) {
    return Flexible(
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 80),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMyMessage
              ? AppColors.myMessageColor.withOpacity(0.5)
              : AppColors.friendMessageColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
        ),
        child: Text(
          message.messageContent!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget messageTypeImage(BuildContext context, bool isMyMessage) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ImageScreen(path: message.path!));
      },
      child: Container(
        width: 200,
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        // padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isMyMessage
                ? AppColors.myMessageColor
                : AppColors.friendMessageColor,
            width: 3,
          ),
          borderRadius: isMyMessage
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
        ),
        child: ClipRRect(
          borderRadius: isMyMessage
              ? const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
          child: message.path!.startsWith('https')
              ? CachedNetworkImage(
                  imageUrl: message.path!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : isMyMessage
                  ? Image.file(
                      File(message.path!),
                      fit: BoxFit.cover,
                    )
                  : Skeletonizer(
                      enabled: true,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[300],
                      ),
                    ),
        ),
      ),
    );
  }
}
