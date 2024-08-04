import 'package:chat_app_firebase/model/messege_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  // instance of firestore & auth
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firebaseFirestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Get all users stream except blocked users
  Stream<List<Map<String, dynamic>>> getUserStreamExcludingBlockedusers() {
    final currentUser = _auth.currentUser;
    return _firebaseFirestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // getting blocked user ids
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      //getting all users
      final userSnapshot = await _firebaseFirestore.collection('Users').get();

      // returning as stream list
      return userSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUsersIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });

  }

  // send messeges
  Future<void> sendMessages(String recieverID, message) async {
    // get current user info
    final currentUserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // create new messeges
    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail!,
      recieverID: recieverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // add new messeges to the database
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages") // here was messeges
        .add(newMessage.toMap());
  }

  // get messeges
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Report user

  Future<void> reportUser(String messageID, String userID) async {
    final currentUser = _auth.currentUser;

    final report = {
      'reportedBy': currentUser!.uid,
      'messageID': messageID,
      'messageOwnerID': userID,
      'timestamp': FieldValue.serverTimestamp(),
    };
    // here we are making a new collection in firebase database called " Report " and adding the data to that by adding the report
    await _firebaseFirestore.collection('Report').add(report);
  }

  // Block User
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;
    await _firebaseFirestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userID)
        .set({});
    notifyListeners();
  }

  // Unblock User
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _auth.currentUser;

    _firebaseFirestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserID)
        .delete();
  }

  // Get Blocked User Stream
  Stream<List<Map<String, dynamic>>> getBlockedUsers(String userID) {
    return _firebaseFirestore
        .collection('Users')
        .doc(userID)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //getting list of blocked users
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUsersIds.map(
          (id) => _firebaseFirestore.collection('Users').doc(id).get(),
        ),
      );

      // returning as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
