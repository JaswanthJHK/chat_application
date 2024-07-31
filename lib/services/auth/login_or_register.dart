import 'package:chat_app_firebase/presentation/pages/login_page.dart';
import 'package:chat_app_firebase/presentation/pages/rigister_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void toggledPages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        ontap: toggledPages,
      );
    } else {
      return RegisterPage(
        onTap: toggledPages,
      );
    }
  }
}