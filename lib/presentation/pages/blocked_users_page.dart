import 'package:chat_app_firebase/constants/colors.dart';
import 'package:chat_app_firebase/presentation/pages/home_page_section/widget/user_tile.dart';
import 'package:chat_app_firebase/services/auth/authentication.dart';
import 'package:chat_app_firebase/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatServices chatServices = ChatServices();
  final AuthService authService = AuthService();

  // show confirm unblock box
  void _showUnblockBox(BuildContext context, String userId) {
    Color textColor = Theme.of(context).colorScheme.secondaryContainer;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: Text(
          "U N B L O C K  U S E R",
          style: TextStyle(color: textColor),
        ),
        content: Text(
          "Are you sure you want to Unblock this user?",
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("C A N C E L"),
          ),
          TextButton(
            onPressed: () {
              ChatServices().unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User Unblocked"),
                ),
              );
            },
            child: const Text("U N B L O C K"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = authService.getCurrentUser()!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text("BLOCKED USERS"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColour.grey,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatServices.getBlockedUsers(userId),
        builder: (context, snapshot) {
          // errors...
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading..."),
            );
          }

          // Loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final blockedUsers = snapshot.data ?? [];

          // if no blocked users
          if (blockedUsers.isEmpty) {
            return Center(
              child: Text(
                "No blocked users",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            );
          }

          // loading completed
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user['email'],
                ontap: () => _showUnblockBox(context, user['uid']),
              );
            },
          );

          // Stream builder
        },
      ),
    );
  }
}
