import 'package:chat_app/data/models/conversation.dart';
import 'package:chat_app/data/repositories/chat_repositorie.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController{
  ChatRepositories chatRepositories=Get.put(ChatRepositories());
  RxList<Conversation> listConversations=<Conversation>[].obs;

  Future fetchConversations()async{
    try{
      List<Conversation> conversations=await chatRepositories.fetchConversations();
      listConversations.assignAll(conversations);
      update();
    }catch(e){
      Exception(e);
     CustomSnackBar.showError("faild to laod conversations");
    }
  }

  @override
  void onInit() async{
    await fetchConversations();
    super.onInit();

  }
}