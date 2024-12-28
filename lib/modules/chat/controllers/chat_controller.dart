import 'dart:async';

import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/data/repositories/users_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/utils/services/notification_service.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  final UsersRepositorie _usersRepositories=Get.put(UsersRepositorie());
  final ChatRepositories _chatRepositories=Get.put(ChatRepositories());
  CurrentUserController currentUserController=Get.find();
  ScrollController scrollController=ScrollController();
  StreamSubscription<QuerySnapshot>? streamSubscription;


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

  void startStream(){
    streamSubscription=_chatRepositories.messagesStream(conversation.value.uid!, onData: (List<Message> listMessages){
      messages.assignAll(listMessages);
      update();
    },onError: (error){
      CustomSnackBar.showError("Failed to fetch messages real time. Please try again.");
    });
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
      bool isSender=currentUserController.authUser.value.docId==conversation.value.senderDocId;
      await _chatRepositories.sendMessage(message, conversation.value.uid!,isSender);
      textEditingController.clear();
      String? fcmToken=await _usersRepositories.getUserFcmToken(isSender
          ?conversation.value.receiverDocId ?? ''
          :conversation.value.senderDocId ?? ''
      );
      if(fcmToken!=null){
        await Get.find<NotificationService>().sendNotifications(
            fcmToken: fcmToken,
            title: "Chat App",
            body: "${currentUserController.authUser.value.name} send you message",
            userId: ""
        );
      }

    }catch(e){
      CustomSnackBar.showError("Failed to send your message, please try again.");
      Exception(e);
    }

  }

  @override
  void onInit() async{
    await setConversation();
    startStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    // await fetchMessages();
    super.onInit();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
  }

  setConversation()async{
    conversation.value=Get.arguments["conversation"];
  }
}