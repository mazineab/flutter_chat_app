import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/repositories/global_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:get/get.dart';

class ReceivedPhotosController extends GetxController{
  RxList<Message> listPhotos=<Message>[].obs;
  CurrentUserController currentUserController=Get.find();
  GlobalRepositories globalRepositories=Get.find();
  var loading=false.obs;


  fetchPhotos()async{
    try{
      loading.value=true;
      List<Message> listMessages=await globalRepositories.fetchPhotos(currentUserController.authUser.value.docId);
      listPhotos.assignAll(listMessages);
      loading.value=false;
    }catch(e){
      Exception(e);
    }
  }

  @override
  void onInit() async{
    super.onInit();
    await fetchPhotos();
  }

}