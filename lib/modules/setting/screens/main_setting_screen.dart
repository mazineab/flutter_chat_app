import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/modules/setting/controllers/main_setting_controller.dart';
import 'package:chat_app/widget/ListTiles/custom_list_tile.dart';
import 'package:chat_app/widget/custom_container.dart';
import 'package:chat_app/widget/custom_divider.dart';
import 'package:chat_app/widget/custom_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MainSettingScreen extends StatelessWidget {
  const MainSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainSettingController>(
        init: MainSettingController(),
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              profileListTile(controller.user.value,controller),
              10.verticalSpace,
              secondPart(controller),
              10.verticalSpace,
              const CustomContainer(mainWidget: CustomListTile(title: "This app developed by Mazine Ab",subTitle:"mazinabjlal@gmail.com",))
            ],
          ),
        ),
      ),
    );
  }

  Widget profileListTile(User user,MainSettingController controller) {
    return CustomContainer(
      mainWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomListTile(
            title: "${user.name} ${user.lastName}",
            subTitle: user.email,
            leading:
                CustomProfile(path: user.profilePicture ?? '', picker: false),
          ),
          15.verticalSpace,
          const CustomDivider(),
          Obx(()=>
             CustomListTile(
              title: "Notifications",
              leading: const Icon(Icons.notifications, color: Colors.white),
              trailing: Switch(
                value: controller.isNotificationEnabled.value,
                onChanged: (v)=>controller.switchNotification(),
                // activeColor: Colors.white,
              ),
            ),
          ),
          const CustomDivider(),
          CustomListTile(
            title: "Logout",
            leading: const Icon(Icons.logout, color: Colors.white),
            onTap:controller.logout,
          ),
        ],
      ),
    );
  }
  
  Widget secondPart(MainSettingController controller){
    return CustomContainer(
        mainWidget: Column(
          children: [
            CustomListTile(
              onTap: controller.navigateToEdit,
              leading: const Icon(FontAwesomeIcons.userPen,size: 20,color: Colors.white),
              title: "Edit Your Informations",
              trailing: const Icon(FontAwesomeIcons.angleRight,size: 20,color: Colors.white),
            ),5.verticalSpace,
            const CustomDivider(),
            5.verticalSpace,
            CustomListTile(
              onTap: ()=>controller.navigateToPhotos(),
              leading: Icon(FontAwesomeIcons.image,size: 20,color: Colors.white),
              title: "Photo",
              trailing: Icon(FontAwesomeIcons.angleRight,size: 20,color: Colors.white),
            ),
            const CustomDivider(),
            5.verticalSpace,
            const CustomListTile(
              leading: Icon(FontAwesomeIcons.language,size: 20,color: Colors.white),
              title: "Language",
              trailing: Icon(FontAwesomeIcons.angleRight,size: 20,color: Colors.white),
            ),
            const CustomDivider(),
            5.verticalSpace,
            const CustomListTile(
              leading: Icon(FontAwesomeIcons.question,size: 20,color: Colors.white),
              title: "About us",
              trailing: Icon(FontAwesomeIcons.angleRight,size: 20,color: Colors.white),
            ),

          ],
        )
    );
  }
}
