import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user's contacts
  Stream<List<ContactModel>> getUserContacts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ContactModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Fetch the list of rooms the user is part of
  Stream<List<String>> getUserRooms(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('rooms')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['roomId'] as String).toList();
    });
  }
  
  // Update PTT setting for a contact
  Future<void> updateContactPttSetting(String userId, String contactId, bool pttEnabled) async {
    try {
      await _firestore.collection('users').doc(userId).collection('contacts').doc(contactId).update({
        'pttEnabled': pttEnabled,
      });
    } catch (e) {
      print("Error updating PTT setting: $e");
    }
  }

  // Update contact status (Available, Away, Busy)
  Future<void> updateContactStatus(String userId, String contactId, String status) async {
    try {
      await _firestore.collection('users').doc(userId).collection('contacts').doc(contactId).update({
        'status': status,
      });
    } catch (e) {
      print("Error updating contact status: $e");
    }
  }

  // Fetch user details (name, contacts, etc.)
  Future<UserModel> getUserDetails(String userId) async {
    try {
      var userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data()!);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print("Error fetching user details: $e");
      rethrow;
    }
  }

  // Add a new contact for the user
  Future<void> addContact(String userId, String contactId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('contacts').doc(contactId).set({
        'contactId': contactId,
        'pttEnabled': false,
        'status': 'Available', // Default status
      });

      // Optionally add the contact to the contact list of the contact as well
      await _firestore.collection('users').doc(contactId).collection('contacts').doc(userId).set({
        'contactId': userId,
        'pttEnabled': false,
        'status': 'Available', // Default status
      });
    } catch (e) {
      print("Error adding contact: $e");
    }
  }

  // Remove a contact from the user's contact list
  Future<void> removeContact(String userId, String contactId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('contacts').doc(contactId).delete();

      // Optionally remove the contact from the contact list of the contact as well
      await _firestore.collection('users').doc(contactId).collection('contacts').doc(userId).delete();
    } catch (e) {
      print("Error removing contact: $e");
    }
  }
}
