import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationController extends GetxController{
  final ChatRepositories _chatRepositories=Get.put(ChatRepositories());
  CurrentUserController currentUserController=Get.find();
  Rx<Conversation> conversation=Conversation().obs;
  List<Message> messages=<Message>[].obs;
  List<Message> myMessages=<Message>[].obs;
  List<Message> friendMessages=<Message>[].obs;
  TextEditingController textEditingController=TextEditingController();
  RxBool ableToSend=false.obs;

  checkTextField(){
    if(textEditingController.text.isNotEmpty){
      ableToSend.value=true;
    }else{
      ableToSend.value=false;
    }
    update();
  }


  fetchMessages()async{
    try{
      if(conversation.value.uid != null){
        List<Message> listMessages=await _chatRepositories.fetchMessageOfConversation(conversation.value.uid!);
        messages.assignAll(listMessages);
      }else{
        CustomSnackBar.showError("Failed to fetch messages of this conversation");
      }

    }catch(e){
      print(Exception("$e"));
      CustomSnackBar.showError("Failed to fetch messages. Please try again.");
    }finally{
      update();
    }
  }

  Future<void> sendMessage()async{
    try{
      Message message=Message(
        senderId: currentUserController.authUser.value.docId,
        messageContent: textEditingController.text,
        isRead: false,
        createdAt: Timestamp.fromDate(DateTime.now()),
      );
      await _chatRepositories.sendMessage(message, conversation.value.uid!,currentUserController.authUser.value.docId==conversation.value.senderDocId);
      textEditingController.clear();
    }catch(e){
      CustomSnackBar.showError("Failed to send your message, please try again.");
      Exception(e);
    }

  }

  @override
  void onInit() async{
    await setConversation();
    await fetchMessages();
    super.onInit();
  }

  setConversation()async{
    conversation.value=Get.arguments["conversation"];
  }
}