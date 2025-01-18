import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendMessageDialog {
  static Future<void> show(BuildContext context,
      {required String sndrUid, required String rcvrUid}) async {
    bool isSender = Get.find<CurrentUserController>().authUser.value.docId == sndrUid;
    TextEditingController messageController = TextEditingController();
    ChatRepositories chatRepositories = Get.put(ChatRepositories());

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.oldBgColor,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Send Message",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: messagePart(
                      onSend: () {
                        String message = messageController.text.trim();
                        if (message.isNotEmpty) {
                          chatRepositories.createConversation(
                            sndrUid,
                            rcvrUid,
                            message,
                            isSender,
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message cannot be empty"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      textController: messageController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget messagePart({
    required TextEditingController textController,
    required VoidCallback onSend,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.myMessageColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: TextField(
                controller: textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Write your message...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          sendWidget(onTap: onSend),
        ],
      ),
    );
  }

  static Widget sendWidget({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap, // Trigger the onSend callback when tapped
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xFF3d4354),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        child: const Icon(
          size: 20,
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }
}
