import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:overtime_managment/admin/managnotification.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize(Function(NotificationModel) onNotificationReceived) async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('Permission denied');
    }

    // Get and print Firebase Token
    String? token = await _messaging.getToken();
    print("Firebase Token: $token");

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notification = NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch,
          title: message.notification!.title ?? "No Title",
          message: message.notification!.body ?? "No Body",
          timestamp: DateTime.now(),
        );
        onNotificationReceived(notification);
      }
    });
  }

  Future<void> sendNotificationToUser(String token, String title, String body) async {
    final url = "https://fcm.googleapis.com/fcm/send";
    final serverKey = "YOUR_SERVER_KEY"; // Replace with your Firebase server key

    final payload = {
      "to": token,
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$serverKey",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully.");
    } else {
      print("Failed to send notification: ${response.body}");
    }
  }
}
