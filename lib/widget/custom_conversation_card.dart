import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/widget/controllers/custom_conversation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomConversationCard extends StatelessWidget {
  final Conversation conversation;
  CustomConversationCard({super.key, required this.conversation}) {
    final controller = Get.put(
      CustomConversationController(),
      tag: conversation.uid.toString(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initConversation(conversation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomConversationController>(tag: conversation.uid.toString());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/user_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  )
              ),

              /// online part
              // if (true)
              //   Positioned(
              //     right: 0,
              //     bottom: 0,
              //     child: Container(
              //       width: 16,
              //       height: 16,
              //       decoration: BoxDecoration(
              //         color: Colors.green,
              //         shape: BoxShape.circle,
              //         border: Border.all(
              //           color: Theme.of(context).scaffoldBackgroundColor,
              //           width: 2,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),


          const SizedBox(width: 12),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(()=>
                       Text(
                        controller.fullName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                      Obx(()=>
                        Text(
                          controller.dateTime.value,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                ///read part
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.messages?.last.messageContent ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    controller.readWidget(conversation.messages??[],context)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  

}