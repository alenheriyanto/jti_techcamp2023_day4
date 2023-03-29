import 'package:flutter/material.dart';
import 'package:jtitechcamp_day4_chat_app/pages/chat_page.dart';
import 'package:jtitechcamp_day4_chat_app/pages/login_page.dart';
import 'package:jtitechcamp_day4_chat_app/pages/register_page.dart';
import 'package:jtitechcamp_day4_chat_app/pages/splahscreen_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://gkntjanretbwawyjwozb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdrbnRqYW5yZXRid2F3eWp3b3piIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk2ODg1MjcsImV4cCI6MTk5NTI2NDUyN30.5formAJoBHNLEbt55Ye8YTW2O2TJrmwb5V_t3r9Jp9Q');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreenPage(),
    );
  }
}
