import 'package:chat_app/data/repositories/auth_repositorie.dart';
import 'package:chat_app/modules/chat/screens/chat_screen.dart';
import 'package:chat_app/modules/chat/screens/setting_screen.dart';
import 'package:chat_app/modules/chat/screens/users_screen.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:chat_app/widget/dialogs/dialog_loader.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:get/get.dart';

class MainHomeController extends GetxController{
  AuthRepositories authRepositories=Get.put(AuthRepositories());

  final List pages=[
    ChatScreen(),
    UsersScreen(),
    SettingScreen()
  ];
  RxInt selectedIndex=0.obs;

  onTapItem(int index){
    selectedIndex.value=index;
    update();
  }

  Future<void> logout()async{
    DialogLoader.showLoadingDialog();
    try{
      await authRepositories.logout();
      Get.close(1);
      Get.offAllNamed(RoutesNames.login);
    }catch(e){
      Get.close(1);
      CustomSnackBar.showError("Error same thing went wrong try again please");

    }
  }

}