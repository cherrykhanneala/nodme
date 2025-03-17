import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../models/contact_model.dart';

class ContactSettingsScreen extends StatefulWidget {
  final String userId;

  const ContactSettingsScreen({super.key, required this.userId});

  @override
  _ContactSettingsScreenState createState() => _ContactSettingsScreenState();
}

class _ContactSettingsScreenState extends State<ContactSettingsScreen> {
  late Stream<List<ContactModel>> _contactsStream;

  @override
  void initState() {
    super.initState();
    _contactsStream = context.read<UserService>().getUserContacts(widget.userId);
  }

  Future<void> _togglePtt(ContactModel contact) async {
    bool newPttSetting = !contact.pttEnabled;
    await context.read<UserService>().updateContactPttSetting(
      widget.userId,
      contact.contactId,
      newPttSetting,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Settings")),
      body: StreamBuilder<List<ContactModel>>(
        stream: _contactsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No contacts available"));
          }

          List<ContactModel> contacts = snapshot.data!;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              ContactModel contact = contacts[index];
              return ListTile(
                title: Text(contact.contactId),
                subtitle: Text("Status: ${contact.status}"),
                trailing: Switch(
                  value: contact.pttEnabled,
                  onChanged: (value) {
                    _togglePtt(contact);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
