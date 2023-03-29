import 'package:flutter/material.dart';
import 'package:jtitechcamp_day4_chat_app/constants.dart';
import 'package:jtitechcamp_day4_chat_app/pages/chat_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const LoginPage(),
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: formPadding,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Email")),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }

                  return null;
                },
                controller: emailController,
              ),
              formSpacer,
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(label: Text("Password")),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }

                  if (val.length < 6) {
                    return '6 characters minimum';
                  }

                  return null;
                },
                controller: passwordController,
              ),
              formSpacer,
              ElevatedButton(
                  onPressed: _isLoading ? null : signIn,
                  child: const Text("Login")),
            ],
          )),
    );
  }

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signInWithPassword(
          email: emailController.text, password: passwordController.text);

      Navigator.pushAndRemoveUntil(context, ChatPage.route(), (route) => false);
    } on AuthException catch (error) {
      context.showErrorSnackbar(message: error.message);
    } catch (_) {
      context.showErrorSnackbar(message: errorSupabase);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
