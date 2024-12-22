import 'package:chat_app/widget/custom_conversation_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/conversations_controller.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ConversationsController>(builder: (controller)=>
        RefreshIndicator(
          onRefresh: ()async=>await controller.fetchConversations(),
          child: ListView.builder(
              itemCount: controller.listConversations.length,
              itemBuilder: (context,index){
                return InkWell(
                  enableFeedback: false,
                    onTap: (){
                      controller.setConversation(controller.listConversations[index]);
                    },
                    child: CustomConversationCard(
                    conversation:controller.listConversations[index])
                );
              }
          ),
        ),
      ),
    );
  }
}
