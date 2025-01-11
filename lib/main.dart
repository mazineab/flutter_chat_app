import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:chat_app/utils/constants/app_colors.dart';
import 'package:chat_app/utils/local_storage/shared_pred_manager.dart';
import 'package:chat_app/utils/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Get.put(SharedPredManager()).init();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: dotenv.env['API_KEY']!,
        appId: dotenv.env['APP_ID']!,
        messagingSenderId: dotenv.env['messagingSenderId']!,
        projectId: dotenv.env['projectId']!
    )
  );
  NotificationService notificationService=Get.put(NotificationService());
  notificationService.initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.bgColors,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        getPages: Routes.getApp(),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? RoutesNames.login
            : RoutesNames.home,
      ),
    );
  }
}
