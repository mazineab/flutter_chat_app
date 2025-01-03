import 'dart:async';

import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../routes/routes_names.dart';

class ConversationsController extends GetxController{
  CurrentUserController currentUserController=Get.find();
  final ChatRepositories _chatRepositories=Get.put(ChatRepositories());
  RxList<Conversation> listConversations=<Conversation>[].obs;
  Rx<Conversation> conversation=Conversation().obs;
  StreamSubscription<QuerySnapshot>? streamSubscription;
  RxBool isLoad=false.obs;

  Future fetchConversations()async{
    try{
      List<Conversation> conversations=await _chatRepositories.fetchConversations();
      conversations.sort((a,b)=>b.lastMessageAt!.compareTo(a.lastMessageAt!));
      listConversations.assignAll(conversations);
      update();
    }catch(e){
      Exception(e);
      CustomSnackBar.showError("Failed to load conversations. Please try again.");
    }
  }

  setConversation(Conversation conversationValue){
    Get.toNamed(RoutesNames.chatScreen,arguments: {"conversation":conversationValue});
    conversation.value=conversationValue;
    markConversationAsRead();
  }

  markConversationAsRead()async{
    bool isSender=currentUserController.authUser.value.docId==conversation.value.senderDocId;
    _chatRepositories.markConversationAsRead(conversation.value,isSender);
  }

  void startListing(){
    try{
      isLoad.value=true;
      streamSubscription=_chatRepositories.conversationStream(
          onData: (List<Conversation> conversations){
            conversations.sort((a,b)=>b.lastMessageAt!.compareTo(a.lastMessageAt!));
            listConversations.assignAll(conversations);
            isLoad.value=false;
            update();
          },
          onError: (error){
            CustomSnackBar.showError("Failed to load realtime conversations. Please try again.");
          }
      );
    }catch(e){
      throw Exception(e);
    }finally{

    }

  }

  @override
  void onInit() async{
    startListing();
    // await fetchConversations();
    super.onInit();
  }
}