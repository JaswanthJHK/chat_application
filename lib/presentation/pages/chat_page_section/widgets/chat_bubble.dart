import 'package:chat_app_firebase/constants/sizes.dart';
import 'package:chat_app_firebase/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  // show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    Color iconColor = Theme.of(context).colorScheme.secondaryContainer;

    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            // report message
            ListTile(
              leading: Icon(Icons.flag_outlined, color: iconColor),
              title: Text(
                "  R E P O R T",
                style: TextStyle(color: iconColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(context, messageId, userId);
              },
            ),

            // block user
            ListTile(
              leading: Icon(Icons.block, color: iconColor),
              title: Text(
                "  B L O C K",
                style: TextStyle(color: iconColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),

            // cancel
            ListTile(
              leading: Icon(Icons.cancel_outlined, color: iconColor),
              title: Text(
                "  C A N C E L",
                style: TextStyle(color: iconColor),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Appsizes.sizeSixty,
          ],
        ));
      },
    );
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    Color textColor = Theme.of(context).colorScheme.secondaryContainer;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: Text(
          "R E P O R T  U S E R",
          style: TextStyle(color: textColor),
        ),
        content: Text(
          "Are you sure you want to report this user?",
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
              ChatServices().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Message Reported"),
                ),
              );
            },
            child: const Text("R E P O R T"),
          ),
        ],
      ),
    );
  }

  // block user
  void _blockUser(BuildContext context, String userId) {
    Color textColor = Theme.of(context).colorScheme.secondaryContainer;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: Text(
          "B L O C K  U S E R",
          style: TextStyle(color: textColor),
        ),
        content: Text(
          "Are you sure you want to Block this user?",
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
              ChatServices().blockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User Blocked"),
                ),
              );
            },
            child: const Text("B L O C K"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Radius radiusCurv = const Radius.circular(20);
    var chatColor = isCurrentUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiaryContainer;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
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
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        child: Text(
          message,
          style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
