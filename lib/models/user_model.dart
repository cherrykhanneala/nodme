class UserModel {
  final String userId; // Unique user identifier
  final String name; // Name of the user
  final List<String> contactIds; // List of contacts' IDs (for contact management)
  final List<String> rooms; // List of room IDs the user is part of (for group chats)
  final String phoneNumber; // The user's phone number

  UserModel({
    required this.userId,
    required this.name,
    required this.contactIds,
    required this.rooms,
    required this.phoneNumber,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'contactIds': contactIds,
      'rooms': rooms,
      'phoneNumber': phoneNumber,
    };
  }

  // Convert Map to UserModel
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      contactIds: List<String>.from(map['contactIds']),
      rooms: List<String>.from(map['rooms']),
      phoneNumber: map['phoneNumber'],
    );
  }
}
