import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/enums/message_type.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/widget/image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMyMessage;
  final Map<String,VoidCallback>? audioFunctions;
  final RxBool isPlaying;
  final String? path;
  final RxInt? audioDuration;
  const MessageWidget(
      {super.key,required this.message, required this.isMyMessage,
        this.audioFunctions,required this.isPlaying,this.path,
        this.audioDuration,
});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        chooseMessage(context)
      ],
    );
  }

  Widget chooseMessage(BuildContext context){
    switch (message.messageType){
      case MessageType.text:
        return messageTypeText(context);
      case MessageType.image:
        return messageTypeImage(context, isMyMessage);
      case MessageType.audio:
        return messageTypeAudio(isMyMessage);
      default:
        return const SizedBox();
    }
  }

  Widget messageTypeText(BuildContext context) {
    return Flexible(
      child: Container(
        constraints: BoxConstraints(maxWidth:0.75.sw),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMyMessage
              ? AppColors.myMessageColor.withOpacity(0.6)
              : AppColors.friendMessageColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
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
          child:  message.isUpload!=null && !message.isUpload!
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

  Widget messageTypeAudio(bool isMyMessage) {
    return Obx(() {
      return Container(
        height: 50,
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isMyMessage
              ? AppColors.myMessageColor.withOpacity(0.5)
              : AppColors.friendMessageColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              audioDurationWidget(),
              if (message.isUpload!)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                IconButton(
                  onPressed: !isPlaying.value
                      ? (audioFunctions?['startAudio'])
                      : (audioFunctions?['pauseAudio']),
                  icon: Icon(
                    !isPlaying.value
                        ? Icons.play_circle
                        : (path == message.path ? Icons.pause : Icons.play_circle),
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }




  Widget audioDurationWidget(){
        if(path==message.path && message.audioDuration!=null && isPlaying.value){
          return counterWidget(audioDuration!.value);
        }else if(message.audioDuration!=null && !isPlaying.value){
            return counterWidget(message.audioDuration!);
          }else if(message.audioDuration!=null && path!=message.path && isPlaying.value){
          return counterWidget(message.audioDuration!);
        }
        return const SizedBox();
      }

    Widget counterWidget(int value){
      return Text(
        "00:${value.toString().length < 2 ? '0$value' : value}",
        style:const TextStyle(color: Colors.white),
      );
    }
}
