class StoryModel {
  final String userId; // The ID of the user who uploaded the story
  final String storyImage; // URL of the image/video for the story
  final String timestamp; // The timestamp when the story was uploaded
  final String expiresAt; // The expiration time (24 hours after upload)
  final List<String> viewers; // List of user IDs who have viewed the story

  StoryModel({
    required this.userId,
    required this.storyImage,
    required this.timestamp,
    required this.expiresAt,
    required this.viewers,
  });

  // Convert StoryModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'storyImage': storyImage,
      'timestamp': timestamp,
      'expiresAt': expiresAt,
      'viewers': viewers,
    };
  }

  // Convert Map to StoryModel
  static StoryModel fromMap(Map<String, dynamic> map) {
    return StoryModel(
      userId: map['userId'],
      storyImage: map['storyImage'],
      timestamp: map['timestamp'],
      expiresAt: map['expiresAt'],
      viewers: List<String>.from(map['viewers']),
    );
  }
}
