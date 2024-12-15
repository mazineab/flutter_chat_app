import 'package:chat_app/modules/chat/controllers/chat_screen_controller.dart';
import 'package:chat_app/widget/custom_conversation_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatScreenController>(builder: (controller)=>
        RefreshIndicator(
          onRefresh: ()async=>await controller.fetchConversations(),
          child: ListView.builder(
              itemCount: controller.listConversations.length,
              itemBuilder: (context,index){
                return CustomConversationCard(conversation:controller.listConversations[index]);
              }
          ),
        ),
      ),
    );
  }
}
