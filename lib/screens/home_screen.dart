import 'package:flutter/material.dart';
import 'stories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoriesScreen(userId: 'currentUserId')),
                );
              },
              child: Text("Go to Stories"),
            ),
            // You can add more buttons/screens to navigate to different sections of the app.
          ],
        ),
      ),
    );
  }
}
