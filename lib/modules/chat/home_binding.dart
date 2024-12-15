import 'package:chat_app/modules/chat/controllers/chat_screen_controller.dart';
import 'package:chat_app/modules/chat/controllers/main_home_controller.dart';
import 'package:chat_app/modules/chat/controllers/users_controller.dart';
import 'package:chat_app/modules/current_user_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainHomeController());
    Get.put(CurrentUserController());
    Get.put(ChatScreenController());
    Get.put(UsersController());
  }
}
