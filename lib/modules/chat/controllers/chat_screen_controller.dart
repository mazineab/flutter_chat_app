import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:get/get.dart';

import '../../../routes/routes_names.dart';

class ChatScreenController extends GetxController{
  CurrentUserController currentUserController=Get.find();
  ChatRepositories chatRepositories=Get.put(ChatRepositories());
  RxList<Conversation> listConversations=<Conversation>[].obs;
  Rx<Conversation> conversation=Conversation().obs;

  Future fetchConversations()async{
    try{
      List<Conversation> conversations=await chatRepositories.fetchConversations();
      listConversations.assignAll(conversations);
      update();
    }catch(e){
      Exception(e);
      CustomSnackBar.showError("Failed to load conversations. Please try again.");
    }
  }

  setConversation(Conversation conversationValue){
    Get.toNamed(RoutesNames.conversationScreen,arguments: {"conversation":conversationValue});
    conversation.value=conversationValue;
    markConversationAsRead();
  }

  markConversationAsRead()async{
    bool isSender=currentUserController.authUser.value.docId==conversation.value.senderDocId;
    chatRepositories.markConversationAsRead(conversation.value,isSender);
  }

  @override
  void onInit() async{
    await fetchConversations();
    super.onInit();

  }
}