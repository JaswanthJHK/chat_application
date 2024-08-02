import 'package:chat_app_firebase/model/messege_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  // instance of firestore & auth
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firebaseFirestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // send messeges
  Future<void> sendMesseges(String recieverID, messege) async {
    // get current user info
    final currentUserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // create new messeges
    Message newMessege = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail!,
      recieverID: recieverID,
      message: messege,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, recieverID];
    ids.sort();
    String chatRoomID = ids.join();

    // add messeges to the database
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messeges")
        .add(newMessege.toMap());
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
}
