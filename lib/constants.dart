import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const formSpacer = SizedBox(
  width: 16,
  height: 16,
);

const formPadding = EdgeInsets.all(16);

const preLoader = Center(
  child: CircularProgressIndicator(
    color: Colors.orange,
  ),
);

final supabase = Supabase.instance.client;

const errorSupabase = "gatau errornya apa";

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void showErrorSnackbar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
