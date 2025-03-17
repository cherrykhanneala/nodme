import 'package:flutter/material.dart';
import '../models/story_model.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  final Function onView; // Function to mark the story as viewed

  const StoryCard({required this.story, required this.onView, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime expirationTime = DateTime.parse(story.expiresAt);
    bool isExpired = DateTime.now().isAfter(expirationTime);

    return isExpired
        ? SizedBox.shrink() // Do not show expired stories
        : Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(story.storyImage, width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text("Story by ${story.userId}"),
              subtitle: Text("Expires at: ${story.expiresAt}"),
              trailing: IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  onView(story); // Call the onView callback to mark the story as viewed
                },
              ),
            ),
          );
  }
}
