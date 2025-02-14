import 'package:chat_app/modules/main_home_controller.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainHome extends StatelessWidget {
  MainHome({super.key});
  MainHomeController mainHomeController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(
        title: const Text("Chatyy",style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.bgColors,
      ),
      bottomNavigationBar: GetBuilder<MainHomeController>(
        builder: (_)=>
            FlashyTabBar(
          selectedIndex: mainHomeController.selectedIndex.value,
          showElevation: true,
          backgroundColor: AppColors.bgColors,

          items: [
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: const Icon(FontAwesomeIcons.solidComments,color: Colors.white,),
              title: Text('Chats',style: GoogleFonts.nunito(color: Colors.white)),
            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: const Icon(Icons.groups,color: Colors.white,),
              title: Text('Friends',style: GoogleFonts.nunito(color: Colors.white)),
            ),
            FlashyTabBarItem(
              activeColor: Colors.white,
              icon: const Icon(Icons.settings,color: Colors.white,),
              title: Text('Settings',style: GoogleFonts.nunito(color: Colors.white)),
            ),
          ],
              onItemSelected: mainHomeController.onTapItem,
        ),
      ),
      body: Obx((){
        return mainHomeController.pages[mainHomeController.selectedIndex.value];
      }),
    );
  }
}
