import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/story_service.dart';
import '../models/story_model.dart';

class ViewersScreen extends StatelessWidget {
  final String storyId;

  const ViewersScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Viewers")),
      body: FutureBuilder<StoryModel>(
        future: context.read<StoryService>().getStoryById(storyId).then((story) => story ?? StoryModel(
          userId: '', 
          storyImage: '', 
          timestamp: DateTime.now().toIso8601String(), 
          expiresAt: DateTime.now().add(Duration(hours: 24)).toIso8601String(), 
          viewers: []
        )),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Story not found"));
          }

          StoryModel story = snapshot.data!;
          return ListView.builder(
            itemCount: story.viewers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Viewer: ${story.viewers[index]}"),
              );
            },
          );
        },
      ),
    );
  }
}
