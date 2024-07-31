import 'package:chat_app_firebase/auth/authentication.dart';
import 'package:chat_app_firebase/presentation/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future logOut() async {
    final auth = AuthService();
    auth.userSignOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
       
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: const Center(
        child: Text("helloo"),
      ),
      drawer:const MyDrawer(),
    );
  }
}
