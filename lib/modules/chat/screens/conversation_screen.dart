import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/modules/chat/controllers/conversation_controller.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.bgColors,
          title: const Text("Conversation",style: TextStyle(color: Colors.white),)),
      body: GetBuilder<ConversationController>(
        init: ConversationController(),
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
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
          );
        },
      ),
    );
  }

  Widget messagePart(TextEditingController textController, bool enable,
      VoidCallback onChange,
  Future<void> Function() onTap) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo)),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                  hintText: "Write your message...", border: InputBorder.none),
              onChanged: (e) => onChange(),
            ),
          )),
          enable
              ? IconButton(
                  enableFeedback: enable,
                  onPressed: () async => await onTap(),
                  icon: const Icon(Icons.send))
              : const SizedBox(),
        ],
      ),
    );
  }
}
