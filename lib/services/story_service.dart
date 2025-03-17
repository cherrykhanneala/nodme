import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';
import 'push_notification_service.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PushNotificationService _pushNotificationService = PushNotificationService();

  // Get story by its ID
  Future<StoryModel?> getStoryById(String storyId) async {
    try {
      var doc = await _firestore.collection('stories').doc(storyId).get();
      if (doc.exists) {
        return StoryModel.fromMap(doc.data()!);  // Returning the story as a StoryModel
      }
    } catch (e) {
      print("Error getting story by ID: $e");
    }
    return null;  // Returning null if the story doesn't exist or an error occurred
  }
  
  // Upload a new story
  Future<void> uploadStory(String userId, String storyImage) async {
    try {
      String storyId = _firestore.collection('stories').doc().id;
      String timestamp = DateTime.now().toString();
      String expiresAt = DateTime.now().add(Duration(hours: 24)).toString(); // Expire after 24 hours

      StoryModel story = StoryModel(
        userId: userId,
        storyImage: storyImage,
        timestamp: timestamp,
        expiresAt: expiresAt,
        viewers: [], // Initially, no viewers
      );

      await _firestore.collection('stories').doc(storyId).set(story.toMap());

      // Notify contacts about the new story
      await _pushNotificationService.sendStoryNotification(userId, storyId);

      // Remove expired stories
      _removeExpiredStories();
    } catch (e) {
      print("Error uploading story: $e");
    }
  }

  // Remove expired stories
  Future<void> _removeExpiredStories() async {
    try {
      String currentTime = DateTime.now().toString();
      var querySnapshot = await _firestore.collection('stories')
          .where('expiresAt', isLessThanOrEqualTo: currentTime)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete(); // Delete expired story
      }
    } catch (e) {
      print("Error removing expired stories: $e");
    }
  }

  // Mark a story as viewed
  Future<void> markStoryAsViewed(String storyId, String userId) async {
    try {
      await _firestore.collection('stories').doc(storyId).update({
        'viewers': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print("Error marking story as viewed: $e");
    }
  }

  // Get all stories (to display)
  Stream<List<StoryModel>> getStories() {
    return _firestore.collection('stories')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return StoryModel.fromMap(doc.data());
      }).toList();
    });
  }
}
