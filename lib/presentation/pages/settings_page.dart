import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S E T T I N G S"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("S E T T I N G S"),
      ),
    );
  }
}