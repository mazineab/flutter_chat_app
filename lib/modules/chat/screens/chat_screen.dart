import 'package:chat_app/data/models/enums/message_type.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/widget/custom_divider.dart';
import 'package:chat_app/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.bgColors,
                  title: Text(
                    controller.friendFullName.value,
                    style: const TextStyle(color: Colors.white),
                  )),
              body: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(()=> Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: controller.rxGroupedMessages.keys.length,
                        itemBuilder: (context, index) {
                          final date = controller.rxGroupedMessages.keys.elementAt(index);
                          final messages = controller.rxGroupedMessages[date]!;
                          return Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Section title (Date)
                              dateWidget(date),
                              /// Photos grid
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                reverse: true,
                                controller: controller.scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  Message message = messages[index];
                                  bool isMyMessage = controller
                                          .currentUserController.authUser.value.docId ==
                                      message.senderId;
                                  return MessageWidget(
                                    message: message,
                                    isMyMessage: isMyMessage,
                                    audioFunctions:
                                    message.messageType==MessageType.audio?
                                        {"startAudio":()=>controller.startAudioPlayback(message.path!),"pauseAudio":()=>controller.pausePlaying()}
                                        // ()=>controller.startAudioPlayback(message.path!)
                                        :null,
                                    isPlaying: controller.isAudioPlaying.value,
                                    path: controller.currentAudioPath.value,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  Obx(()=>
                     messagePart(
                        chatController: controller,
                        textController: controller.textEditingController,
                        enable: controller.ableToSend.value,
                        isRecording: controller.isRecording.value,
                        onChange: controller.checkTextField,
                        onSend: controller.sendMessage,
                        onCameraTap: controller.uploadFromGallery,
                        onRecording: controller.startAudioRecording,
                        onCancelRecord: controller.cancelAudioRecording,
                        onSendAudio:controller.finishAudioRecording
                    ),
                  )
                ],
              ));
        });
  }

  Widget dateWidget(String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width:100,child: CustomDivider(color: AppColors.friendMessageColor)),
        Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(width:100,child: CustomDivider(color: AppColors.friendMessageColor)),
      ],
    );
  }

  Widget messagePart(
      {required ChatController chatController,
      required TextEditingController textController,
      required bool enable,
      required bool isRecording,
      required VoidCallback onChange,
      required Future<void> Function() onSend,
      required VoidCallback onCameraTap,
      required VoidCallback onRecording,
      required VoidCallback onCancelRecord,
      required VoidCallback onSendAudio
      }) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.myMessageColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(50)),
      child: isRecording
          ? recordingWidget(onCancelRecord,onSendAudio)
          : Row(
              children: [
                iconWidget(
                    !chatController.ableToSendPicture.value
                        ?(){
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        const SnackBar(
                          content: Text("You cannot send pictures right now."),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                    :onCameraTap,Icons.camera_alt),
                const SizedBox(width: 5),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Write your message...",
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 15)),
                    onChanged: (e) => onChange(),
                  ),
                )),
                displayedWidget(enable, isRecording, onSend, onRecording)
              ],
            ),
    );
  }

  Widget moreWidget({required VoidCallback onRecord}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          iconWidget(onRecord, Icons.mic),
          iconWidget(() {}, Icons.more_vert)
        ],
      ),
    );
  }

  Widget iconWidget(VoidCallback onTap, IconData iconData) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF3d4354),
              borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Icon(
            iconData,
            color: Colors.white,
          )),
    );
  }

  Widget sendWidget(VoidCallback onTap, IconData iconData) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 80,
          decoration: BoxDecoration(
              color: const Color(0xFF3d4354),
              borderRadius: BorderRadius.circular(50)),
          margin: const EdgeInsets.only(right: 5),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          child: Icon(
            iconData,
            color: Colors.white,
          )),
    );
  }

  Widget recordingWidget(VoidCallback onCancelRecord,VoidCallback onSendAudio) {
    return Row(
      children: [
        TextButton(onPressed: onCancelRecord, child: const Text("Cancel")),
        const Text("00:00", style: TextStyle(color: Colors.white)),
        const Spacer(),
        sendWidget(onSendAudio, Icons.send_sharp)
      ],
    );
  }

  Widget displayedWidget(bool enable, bool isRecord, VoidCallback onSend,
      VoidCallback onRecording) {
    if (enable) {
      return sendWidget(onSend, Icons.send);
    } else if (!enable && isRecord) {
      return const SizedBox();
    } else {
      return moreWidget(onRecord: onRecording);
    }
  }
}
