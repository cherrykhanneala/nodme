import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../models/contact_model.dart';
import '../widgets/push_to_talk_button.dart';

class RoomChatScreen extends StatefulWidget {
  final String roomId;
  final String userId;

  const RoomChatScreen({super.key, required this.roomId, required this.userId});

  @override
  _RoomChatScreenState createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  late Stream<List<ContactModel>> _contactsStream;
  final TextEditingController _messageController = TextEditingController();
  String message = "";

  @override
  void initState() {
    super.initState();
    _contactsStream = context.read<UserService>().getUserContacts(widget.userId);
  }

  // Send the message to the chat
  Future<void> _sendMessage() async {
    if (message.isNotEmpty) {
      // Here, you should add the logic to send the message to Firestore or Firebase Realtime Database
      print("Message sent: $message");
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Room Chat")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Display contacts with PTT enabled (if relevant)
            Expanded(
              child: StreamBuilder<List<ContactModel>>(
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
                        subtitle: Text("Status: ${contact.status}"),
                        trailing: contact.pttEnabled
                            ? PushToTalkButton(
                                onPressed: () {
                                  // Implement Push-to-Talk functionality here
                                  print("Push-to-Talk pressed");
                                },
                              )
                            : SizedBox.shrink(),
                      );
                    },
                  );
                },
              ),
            ),

            // Message input area
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
