// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendStoryNotification(String userId, String storyId) async {
    try {
      await _firebaseMessaging.subscribeToTopic(userId);

      await _firebaseMessaging.sendMessage(
        to: 'some_fcm_token',
        data: {
          'storyId': storyId,
          'message': 'New story uploaded!',
        },
      );
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print("Permission granted: ${settings.authorizationStatus}");
  }
}
