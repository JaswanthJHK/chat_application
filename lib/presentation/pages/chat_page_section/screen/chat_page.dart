import 'package:chat_app_firebase/constants/colors.dart';
import 'package:chat_app_firebase/presentation/pages/chat_page_section/widgets/chat_bubble.dart';
import 'package:chat_app_firebase/presentation/widgets/custom_textfield.dart';
import 'package:chat_app_firebase/services/auth/authentication.dart';
import 'package:chat_app_firebase/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  ChatPage({super.key, required this.recieverEmail, required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // message text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // adding listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send messages
  void sendMessage() async {
    // if there is something inside the textcontroller
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatServices.sendMessages(
          widget.recieverID, _messageController.text);

      // clear message controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColour.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(context),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatServices.getMessages(widget.recieverID, senderID),
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
          controller: _scrollController,
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
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      alignment: chatAlignment,
      child: Column(
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data['senderID'],
          ),
        ],
      ),
    );

    //
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfield(
                focusNode: myFocusNode,
                hintText: "type a message",
                obscureText: false,
                icon: const Icon(Icons.message),
                controller: _messageController),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 25),
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
