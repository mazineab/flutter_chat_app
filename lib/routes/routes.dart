import 'package:chat_app/modules/auth/auth_bindings.dart';
import 'package:chat_app/modules/auth/screens/login_screen.dart';
import 'package:chat_app/modules/auth/screens/signup_screen.dart';
import 'package:chat_app/modules/chat/home_binding.dart';
import 'package:chat_app/modules/chat/screens/chat_screen.dart';
import 'package:chat_app/modules/main_home.dart';
import 'package:chat_app/modules/setting/screens/edit_information.dart';
import 'package:chat_app/modules/setting/screens/main_setting_screen.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:get/get.dart';

class Routes{
  static getApp()=>[
    GetPage(name: RoutesNames.login, page:()=> LoginScreen(),binding: AuthBindings()),
    GetPage(name: RoutesNames.signup, page:()=>SignupScreen(),binding: AuthBindings()),
    GetPage(name: RoutesNames.home, page:()=>MainHome(),binding: HomeBinding()),
    GetPage(name: RoutesNames.chatScreen,transition: Transition.rightToLeft,transitionDuration: const Duration(milliseconds: 300) ,page:()=>const ChatScreen(),binding: HomeBinding()),
    GetPage(name: RoutesNames.settingScreen, page: ()=>const MainSettingScreen()),
    GetPage(name: RoutesNames.editInformationScreen, page: ()=>const EditInformation(),transition: Transition.fadeIn)
  ];
}