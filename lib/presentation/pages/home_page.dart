import 'package:chat_app_firebase/presentation/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("helloo"),
      ),
      drawer: const MyDrawer(),
    );
  }
}
