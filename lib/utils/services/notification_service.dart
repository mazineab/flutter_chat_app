import 'dart:convert';
import 'package:chat_app/data/models/account_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;

  Future<String?> getFcmToken() async {
    try {
      String? token = await firebaseMessaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  /// Initialize notification listeners
  Future<void> initializeNotifications() async {
    // Request notification permissions (required for iOS)
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted notification permissions");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional notification permissions");
    } else {
      print("User denied notification permissions");
    }

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in foreground:');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    // Listen to messages when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User clicked on the notification:');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    print("Notification listeners initialized.");
  }


  Future<String?> getAccessToken() async {
    final serviceAccountJson = AccountData.serviceAccountJson;

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);

      client.close();
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

  Map<String, dynamic> getBody({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) {
    return {
      "message": {
        "token": fcmToken,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default"
          }
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true}
          }
        },
        "data": {
          "type": type,
          "id": userId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };
  }

  Future<void> sendNotifications({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) async {
    try {
      var serverKeyAuthorization = await getAccessToken();
      String urlEndPoint = dotenv.env['app_url']!;
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKeyAuthorization',
      };
      final requestBody = jsonEncode(getBody(
        userId: userId,
        fcmToken: fcmToken,
        title: title,
        body: body,
        type: type ?? "message",
      ));
      await http.post(
        Uri.parse(urlEndPoint),
        headers: headers,
        body: requestBody,
      );
    } catch (e) {
      Exception(e);
    }
  }

}