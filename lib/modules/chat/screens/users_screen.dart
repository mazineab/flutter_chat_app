import 'package:chat_app/data/models/user.dart' as usr;
import 'package:chat_app/modules/chat/controllers/users_controller.dart';
import 'package:chat_app/widget/ListTiles/custom_user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersController>(builder: (controller){
      return ListView.builder(
          itemCount: controller.listUsers.length,
          itemBuilder: (context,index){
            usr.User user= controller.listUsers[index];
            return CustomUserListTile(user: user);
          }
      );
    });
  }
}
