import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
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
            title: Text(controller.friendFullName.value,style: const TextStyle(color: Colors.white),)),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: controller.scrollController,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      Message message = controller.messages[index];
                      bool isMyMessage =
                          controller.currentUserController.authUser.value.docId ==
                              message.senderId;
                      return MessageWidget(
                        message: message,
                        isMyMessage: isMyMessage,
                      );
                    },
                  ),
                ),
                messagePart(
                    controller.textEditingController,
                    controller.ableToSend.value,
                    controller.checkTextField,
                    controller.sendMessage)
              ],
            ));
          }
        );
  }

  Widget messagePart(TextEditingController textController, bool enable,
      VoidCallback onChange,
  Future<void> Function() onTap) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.myMessageColor.withOpacity(0.3), borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: [
          iconWidget((){},Icons.camera_alt),
          const SizedBox(width: 5),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: TextField(
              controller: textController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(

                  hintText: "Write your message...", border: InputBorder.none,hintStyle: TextStyle(color: Colors.white,fontSize: 15)),
              onChanged: (e) => onChange(),
            ),
          )),
          enable
              ? sendWidget(onTap,Icons.send)
              : moreWidget(),
        ],
      ),
    );
  }
  Widget moreWidget(){
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          iconWidget((){},Icons.mic),
          iconWidget((){},Icons.more_vert)
        ],
      ),
    );
  }

  Widget iconWidget(VoidCallback onTap,IconData iconData){
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF3d4354),
              borderRadius: BorderRadius.circular(20)
          ),
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          child: Icon(iconData,color: Colors.white,)),
    );
  }

  Widget sendWidget(VoidCallback onTap,IconData iconData){
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width:80,
          decoration: BoxDecoration(
              color: const Color(0xFF3d4354),
              borderRadius: BorderRadius.circular(50)
          ),
          margin: const EdgeInsets.only(right: 5),
          padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 8),
          child: Icon(iconData,color: Colors.white,)),
    );
  }
}
