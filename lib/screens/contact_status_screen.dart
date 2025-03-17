import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../models/contact_model.dart';

class ContactStatusScreen extends StatefulWidget {
  final String userId;

  const ContactStatusScreen({super.key, required this.userId});

  @override
  _ContactStatusScreenState createState() => _ContactStatusScreenState();
}

class _ContactStatusScreenState extends State<ContactStatusScreen> {
  late Stream<List<ContactModel>> _contactsStream;

  @override
  void initState() {
    super.initState();
    _contactsStream = context.read<UserService>().getUserContacts(widget.userId);
  }

  Future<void> _updateStatus(ContactModel contact, String newStatus) async {
    await context.read<UserService>().updateContactStatus(widget.userId, contact.contactId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Status")),
      body: StreamBuilder<List<ContactModel>>(
        stream: _contactsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No contacts found"));
          }

          List<ContactModel> contacts = snapshot.data!;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              ContactModel contact = contacts[index];
              return ListTile(
                title: Text("Contact: ${contact.contactId}"),
                subtitle: Text("Current Status: ${contact.status}"),
                trailing: DropdownButton<String>(
                  value: contact.status,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateStatus(contact, newValue);
                    }
                  },
                  items: <String>['Available', 'Away', 'Busy']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
