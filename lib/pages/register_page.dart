import 'package:flutter/material.dart';
import 'package:jtitechcamp_day4_chat_app/constants.dart';
import 'package:jtitechcamp_day4_chat_app/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const RegisterPage(),
    );
  }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
              TextFormField(
                decoration: const InputDecoration(label: Text("Username")),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }

                  final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                  if (isValid == false) {
                    return '3-24 long with alphanumeric or underscore';
                  }

                  return null;
                },
                controller: usernameController,
              ),
              formSpacer,
              ElevatedButton(onPressed: signUp, child: const Text("Register")),
              formSpacer,
              TextButton(
                  onPressed: () {
                    Navigator.push(context, LoginPage.route());
                  },
                  child: const Text("I already have an account"))
            ],
          )),
    );
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    await supabase.auth.signUp(
        password: passwordController.text,
        email: emailController.text,
        data: {'username': usernameController.text}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Pendaftaran berhasil, mohon konfirmasi email anda")));
    });
  }
}
