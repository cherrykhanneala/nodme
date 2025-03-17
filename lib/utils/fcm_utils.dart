import 'package:firebase_messaging/firebase_messaging.dart';

class FCMUtils {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendNotification({
    required String title,
    required String body,
    required String fcmToken,
  }) async {
    try {
      await _firebaseMessaging.sendMessage(
        to: fcmToken,
        data: {
          'title': title,
          'body': body,
        },
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission granted for notifications");
    } else {
      print("Permission denied for notifications");
    }
  }

  Future<String?> getFCMToken() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      return fcmToken;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
}
