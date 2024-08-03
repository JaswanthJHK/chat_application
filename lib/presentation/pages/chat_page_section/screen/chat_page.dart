import 'package:chat_app_firebase/constants/colors.dart';
import 'package:chat_app_firebase/presentation/pages/chat_page_section/widgets/chat_bubble.dart';
import 'package:chat_app_firebase/presentation/widgets/custom_textfield.dart';
import 'package:chat_app_firebase/services/auth/authentication.dart';
import 'package:chat_app_firebase/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      await _chatServices.sendMessages(recieverID, _messageController.text);

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
        backgroundColor: Colors.transparent,
        foregroundColor: AppColour.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(recieverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error vannu");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
   // debugPrint("---------------------====${data["message"]}");
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var chatAlignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    // var chatColor = isCurrentUser ? AppColour.greylight : AppColour.grey;

    return Container(
      margin:const EdgeInsets.all(10),
      alignment: chatAlignment,
      child: Column(
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        ],
      ),
    );

    //
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfield(
                hintText: "type a message",
                obscureText: false,
                icon: const Icon(Icons.message),
                controller: _messageController),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
