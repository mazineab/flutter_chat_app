import 'package:chat_app/data/repositories/auth_repositorie.dart';
import 'package:chat_app/modules/chat/screens/conversations_screen.dart';
import 'package:chat_app/modules/setting/screens/main_setting_screen.dart';
import 'package:chat_app/modules/chat/screens/users_screen.dart';
import 'package:get/get.dart';

class MainHomeController extends GetxController{
  AuthRepositories authRepositories=Get.put(AuthRepositories());

  final List pages=[
    const ConversationsScreen(),
    const UsersScreen(),
    const MainSettingScreen()
  ];
  RxInt selectedIndex=0.obs;

  onTapItem(int index){
    selectedIndex.value=index;
    update();
  }

}