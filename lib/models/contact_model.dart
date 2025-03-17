class ContactModel {
  final String contactId; // The ID of the contact
  final bool pttEnabled; // Push-to-Talk (PTT) setting for this contact
  String status; // Status of the contact (Available, Away, Busy)

  ContactModel({
    required this.contactId,
    required this.pttEnabled,
    this.status = 'Available', // Default to Available
  });

  // Convert ContactModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'contactId': contactId,
      'pttEnabled': pttEnabled,
      'status': status,
    };
  }

  // Convert Map to ContactModel
  static ContactModel fromMap(Map<String, dynamic> map) {
    return ContactModel(
      contactId: map['contactId'],
      pttEnabled: map['pttEnabled'],
      status: map['status'] ?? 'Available', // Default to Available if no status
    );
  }
}
