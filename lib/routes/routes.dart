import 'package:chat_app/modules/auth/auth_bindings.dart';
import 'package:chat_app/modules/auth/screens/login_screen.dart';
import 'package:chat_app/modules/auth/screens/signup_screen.dart';
import 'package:chat_app/modules/chat/home_binding.dart';
import 'package:chat_app/modules/chat/screens/conversation_screen.dart';
import 'package:chat_app/modules/chat/screens/main_home.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:get/get.dart';

class Routes{
  static getApp()=>[
    GetPage(name: RoutesNames.login, page:()=> LoginScreen(),binding: AuthBindings()),
    GetPage(name: RoutesNames.signup, page:()=>SignupScreen(),binding: AuthBindings()),
    GetPage(name: RoutesNames.home, page:()=>MainHome(),binding: HomeBinding()),
    GetPage(name: RoutesNames.conversationScreen, page:()=>const ConversationScreen(),binding: HomeBinding())
  ];
}