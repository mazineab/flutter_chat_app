import 'package:chat_app/data/models/user.dart' as me;
import 'package:chat_app/data/repositories/auth_repositorie.dart';
import 'package:chat_app/data/repositories/global_repositorie.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:get/get.dart';
import '../../../routes/routes_names.dart';
import '../../../widget/dialogs/dialog_loader.dart';
import '../../../widget/snackBars/snack_bars.dart';

class MainSettingController extends GetxController{
  GlobalRepositories globalRepositories=Get.put(GlobalRepositories());
  CurrentUserController currentUserController=Get.find();
  Rx<me.User> user=Rx(me.User.empty());
  RxBool isNotificationEnabled=true.obs;


  Future<void> logout()async{
    DialogLoader.showLoadingDialog();
    try{
      await globalRepositories.logout();
      Get.close(1);
      Get.offAllNamed(RoutesNames.login);
    }catch(e){
      Get.close(1);
      CustomSnackBar.showError("Error same thing went wrong try again please");
    }
  }

  switchNotification()async{
    try{
      await globalRepositories.updateNotificationStatus(user.value.docId, isNotificationEnabled.value);
      isNotificationEnabled.value=!isNotificationEnabled.value;
      // update();
    }catch(e){
      CustomSnackBar.showError("Faild to make this action please try again");
    }
  }

  navigateToEdit(){
    Get.toNamed(RoutesNames.editInformationScreen);
  }



  @override
  void onInit() {
    user=currentUserController.authUser;
    isNotificationEnabled.value=user.value.isNotificationEnabled ?? true;
    super.onInit();
  }
}