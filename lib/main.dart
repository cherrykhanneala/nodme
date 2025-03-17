import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/story_service.dart';
import 'services/push_notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stories_screen.dart';  // Make sure this import is here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthService()),
        Provider(create: (context) => UserService()),
        Provider(create: (context) => StoryService()),
        Provider(create: (context) => PushNotificationService()),
      ],
      child: MaterialApp(
        title: 'Flutter App with Stories and PTT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(), // Login screen route
          '/home': (context) => HomeScreen(), // Home screen route
          '/stories': (context) => StoriesScreen(userId: 'currentUserId'), // Stories screen route
        },
      ),
    );
  }
}
