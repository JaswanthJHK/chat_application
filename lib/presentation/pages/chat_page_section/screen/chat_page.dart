import 'package:chat_app_firebase/services/auth/authentication.dart';
import 'package:chat_app_firebase/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String recieverEmail;
  final String recieverID;

  ChatPage({super.key, required this.recieverEmail, required this.recieverID});

  // message text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  // send messages

  void sendMessage() async {
    // if there is something inside the textcontroller
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatServices.sendMesseges(recieverID, _messageController.text);

      // clear message controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recieverEmail),
        centerTitle: true,
      ),
    );
  }
}
