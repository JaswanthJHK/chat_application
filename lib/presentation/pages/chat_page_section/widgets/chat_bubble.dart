import 'package:chat_app_firebase/constants/colors.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });
  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    Radius radiusCurv =const Radius.circular(20);
    var chatColor = isCurrentUser ? AppColour.greylight : AppColour.grey;

    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      decoration: BoxDecoration(
        color: chatColor,
        borderRadius: isCurrentUser
            ? BorderRadius.only(
                topLeft: radiusCurv,
                bottomLeft: radiusCurv,
                bottomRight: radiusCurv,
                topRight: const Radius.circular(3))
            : BorderRadius.only(
                topRight: radiusCurv,
                bottomRight: radiusCurv,
                bottomLeft: radiusCurv,
                topLeft: const Radius.circular(3)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        message,
        style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white),
      ),
    );
  }
}
