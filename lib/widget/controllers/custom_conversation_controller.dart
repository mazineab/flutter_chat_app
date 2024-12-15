import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../data/models/conversation.dart';
import '../../data/models/message.dart';
import '../../data/repositories/chat_repositorie.dart';
import '../../modules/current_user_controller.dart';

class CustomConversationController extends GetxController{
  ChatRepositories chatRepositories=Get.put(ChatRepositories());
  CurrentUserController currentUser=Get.find();
  RxString fullName=''.obs;
  RxString dateTime=''.obs;

  Widget readWidget(List<Message> messages,BuildContext context){
    int notRaed = countNotRead(messages);
    return notRaed > 0 ? Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
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

  countNotRead(List<Message> messages){
    return messages.where((e)=> e.isRead==false && e.senderId!=currentUser.authUser.value.docId).length;
  }

  getFullName(Conversation conversation)async{
    try{
      String myDocId=currentUser.authUser.value.docId;
      if(myDocId==conversation.senderDocId){
        fullName.value=await chatRepositories.getUserFullName(conversation.receiverDocId!);
      }else{
        fullName.value=await chatRepositories.getUserFullName(conversation.senderDocId!);
      }
    }catch(e){
      throw Exception(e);
    }
  }


  convertTime(Message message) {
    String res=timeago.format(message.createAt!,locale: "en",allowFromNow: true);
    dateTime.value=res;
  }

  void initConversation(Conversation conversation) {
    getFullName(conversation);
    convertTime(conversation.messages!.last);
  }

  @override
  void onInit() {
    super.onInit();
  }
}