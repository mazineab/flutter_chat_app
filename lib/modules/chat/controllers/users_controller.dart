import 'package:chat_app/data/models/user.dart' as usr;
import 'package:chat_app/data/repositories/users_repositorie.dart';
import 'package:chat_app/widget/snackBars/snack_bars.dart';
import 'package:get/get.dart';

class UsersController extends GetxController{
  UsersRepositorie usersRepo=Get.put(UsersRepositorie());
  RxList<usr.User> listUsers=<usr.User>[].obs;
  RxString message=''.obs;


  Future<void> fetchUsers() async {
    try {
      listUsers.assignAll(await usersRepo.fetchUsers());
      if (listUsers.isEmpty) {
        message.value = 'No users in the app yet.';
      }
    } catch (e) {
      message.value = 'Something went wrong. Please try again later.';
      CustomSnackBar.showError("Something went wrong. Please try again.");
    } finally {
      update();
    }
  }


  @override
  void onInit()async {
    super.onInit();
    await fetchUsers();
  }



}