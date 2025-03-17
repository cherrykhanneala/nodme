import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/story_service.dart';
import '../models/story_model.dart';

class StoriesScreen extends StatelessWidget {
  final String userId;

  const StoriesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stories")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Trigger the upload story functionality here
                print("Upload a new story");
              },
              child: Text("Upload Story"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<StoryModel>>(
                stream: context.read<StoryService>().getStories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No stories available"));
                  }

                  List<StoryModel> stories = snapshot.data!;
                  return ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      StoryModel story = stories[index];
                      return ListTile(
                        leading: Image.network(story.storyImage, width: 60, height: 60, fit: BoxFit.cover),
                        title: Text("Story by ${story.userId}"),
                        subtitle: Text("Expires at ${story.expiresAt}"),
                        trailing: IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {
                            // Mark the story as viewed
                            context.read<StoryService>().markStoryAsViewed(story.timestamp, userId);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
