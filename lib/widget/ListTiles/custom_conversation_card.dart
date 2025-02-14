import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/widget/custom_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomConversationCard extends StatelessWidget {
  final Conversation conversation;
  const CustomConversationCard({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Stack(
            children: [
              CustomProfile(
                path: getFriendProfile(conversation),
                picker: false,
              )

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                       Text(
                         getFriendFullName(conversation),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                        Text(
                          getLastMessageTime(conversation.lastMessageAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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
                        conversation.lastMessage ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    readWidget(conversation)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getFriendFullName(Conversation conv){
    CurrentUserController currentUserController=Get.find();
    return conv.senderDocId==currentUserController.authUser.value.docId ? conv.receiverFullName! : conv.senderFullName!;
  }

  String getFriendProfile(Conversation conv){
    CurrentUserController currentUserController=Get.find();
    return conv.senderDocId==currentUserController.authUser.value.docId ? conv.receiverProfilePicture ?? '' : conv.senderProfilePicture??'';
  }

  String getLastMessageTime(Timestamp lastMessageAt)=> timeago.format(lastMessageAt.toDate(),locale: "en",allowFromNow: true);


  Widget readWidget(Conversation conv){
    CurrentUserController currentUserController=Get.find();
    int notRaed = currentUserController.authUser.value.docId==conv.senderDocId? conv.unreadSenderMessages??0:conv.unreadReceiverMessages??0;
    return notRaed > 0 ? Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage("assets/images/bg.gif")
        )
      ),
      child: Text(
        notRaed.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ):const SizedBox();
  }
}
