import 'package:flutter/material.dart';
import 'package:jtitechcamp_day4_chat_app/constants.dart';
import 'package:jtitechcamp_day4_chat_app/pages/chat_page.dart';
import 'package:jtitechcamp_day4_chat_app/pages/register_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: preLoader,
    );
  }

  Future<void> redirect() async {
    await Future.delayed(Duration(seconds: 1));
    final session = supabase.auth.currentSession;

    if (session == null) {
      Navigator.pushAndRemoveUntil(
          context, RegisterPage.route(), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, ChatPage.route(), (route) => false);
    }
  }
}
