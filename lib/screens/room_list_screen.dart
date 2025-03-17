import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import 'room_chat_screen.dart';  // Import RoomChatScreen

class RoomListScreen extends StatelessWidget {
  final String userId;

  const RoomListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rooms")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<String>>(
          stream: context.read<UserService>().getUserRooms(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No rooms available"));
            }

            List<String> rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                String roomId = rooms[index];
                return ListTile(
                  title: Text("Room $roomId"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomChatScreen(
                          roomId: roomId,
                          userId: userId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
