import 'dart:convert';
import 'package:chat_app/utils/local_storage/shared_pred_manager.dart';
import 'package:get/get.dart';
import '../data/models/user.dart';

class CurrentUserController extends GetxController{
  final SharedPredManager prefs = Get.find<SharedPredManager>();
  var authUser=User.empty().obs;

  getUserData() {
    String? userData = prefs.getString("userData");
    if (userData != null && userData.isNotEmpty) {
      authUser.value= User.fromJson(jsonDecode(userData));
    }
  }


  @override
  void onInit()async {
    super.onInit();
    getUserData();
  }

}