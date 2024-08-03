import 'package:chat_app_firebase/constants/colors.dart';
import 'package:chat_app_firebase/presentation/pages/chat_page_section/screen/chat_page.dart';
import 'package:chat_app_firebase/presentation/pages/home_page_section/widget/user_tile.dart';
import 'package:chat_app_firebase/presentation/widgets/drawer_menu.dart';
import 'package:chat_app_firebase/services/auth/authentication.dart';
import 'package:chat_app_firebase/services/chat/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // current user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColour.grey,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
     
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        // error checking
        if (snapshot.hasError) {
          return const Text("Error...");
        }
        // data loading time
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.amberAccent,
            ),
          );
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all user except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recieverEmail: userData["email"],
                  recieverID: userData["uid"],
                ),
              ));
        },
        text: userData["email"],
      );
    } else {
      return Container();
    }
  }
}
