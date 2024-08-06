import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parakeet/models/my_user.dart';
import 'package:parakeet/utility_functions/show_snackbar.dart';
import '../models/my_message.dart';

class FirestoreService extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE NEW USER IN THE 'users' COLLECTION
  Future<void> createNewUser(MyUser newUser, BuildContext context) async {
    final CollectionReference usersCollection = _firestore.collection('users');
    try {
      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());
    } catch (e) {
      showSnackBar(context, 'Error creating new user ($e)');
    }
  }

  // GET A STREAM OF ALL USERS
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }

  //GET A LIST OF ALL USERS EXCEPT THE BLOCKED ONES
  Future<List<DocumentSnapshot>> getUsersExceptBlocked() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    // Get blocked user IDs
    QuerySnapshot blockedSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('blocked_users')
        .get();

    List<String> blockedUserIDs =
    blockedSnapshot.docs.map((doc) => doc.id).toList();

    //GET A SNAPSHOT OF ALL USERS EXCEPT BLOCKED ONES
    QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();

    List<DocumentSnapshot> users = usersSnapshot.docs.where((doc) {
      return !blockedUserIDs.contains(doc.id);
    }).toList();

    return users;
  }

  //SEND A MESSAGE
  Future<void> sendMessage(String receiverID, String message) async {
    try {
      final String currentUserID = _auth.currentUser!.uid;
      final String? currentUserPhone = _auth.currentUser!.phoneNumber;
      final Timestamp timestamp = Timestamp.now();

      Message newMessage = Message(
        senderID: currentUserID,
        senderPhone: currentUserPhone ?? '',
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  //GET MESSAGES BETWEEN TWO USERS
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //REPORT USER
  Future<void> reportUser(String messageID, String userID) async {
    try {
      User? currentUser = _auth.currentUser;
      final report = {
        'reportedBy': currentUser!.uid,
        'messageID': messageID,
        'messageOwnerID': userID,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('reports').add(report);
    } catch (e) {
      print('Error reporting user: $e');
    }
  }

  //BLOCK USER
  Future<void> blockUser(String userID) async {
    try {
      User? currentUser = _auth.currentUser;
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('blocked_users')
          .doc(userID)
          .set({});
      notifyListeners();
    } catch (e) {
      print('Error blocking user: $e');
    }
  }

  //UNBLOCK USER
  Future<void> unblockUser(String userID) async {
    try {
      User? currentUser = _auth.currentUser;
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('blocked_users')
          .doc(userID)
          .delete();
    } catch (e) {
      print('Error unblocking user: $e');
    }
  }

  //GET A STREAM OF BLOCKED USERS
  Stream<QuerySnapshot> getBlockedUsersStream() {
    User? currentUser = _auth.currentUser;
    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blocked_users')
        .snapshots();
  }
}
