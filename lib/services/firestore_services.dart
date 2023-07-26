import 'package:the_nit_community/constants/firebase_constants.dart';

class FirebaseServices {
  static getAllFriends() {
    return fireStore
        .collection(userCollection)
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static getUserDetails() {
    return fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .snapshots();
  }

  static getAllUsers() {
    return fireStore
        .collection(userCollection)
        .orderBy('username', descending: false)
        .snapshots();
  }

  static getFriendDetails({required userID}) {
    return fireStore.collection(userCollection).doc(userID).snapshots();
  }

  static getAllPosts() {
    return fireStore
        .collection(postCollection)
        .orderBy('created_on', descending: true)
        .snapshots();
  }

  static getUserPosts({required userID}) {
    return fireStore
        .collection(postCollection)
        .where('postFromUserID', isEqualTo: userID)
        .orderBy('created_on', descending: true)
        .snapshots();
  }

  static getAllComments({required postID}) {
    return fireStore
        .collection(postCollection)
        .doc(postID)
        .collection(commentsCollection)
        .orderBy('commented_on', descending: true)
        .snapshots();
  }

  static getUserNotifications({required userID}) {
    return fireStore
        .collection(userCollection)
        .doc(userID)
        .collection(notificationCollections)
        .orderBy('notification_created_on', descending: true)
        .snapshots();
  }

  static getPost({required postID}) {
    return fireStore.collection(postCollection).doc(postID).snapshots();
  }

  static getSearchedUsers({required query}) {
    return fireStore
        .collection(userCollection)
        .where('username', isGreaterThanOrEqualTo: query)
        .snapshots();
  }

  static getMessages({required chatDocID}) {
    return fireStore
        .collection(chatCollection)
        .doc(chatDocID)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getAllChats() {
    return fireStore
        .collection(chatCollection)
        .orderBy('created_on', descending: true)
        .snapshots();
  }

  static getMyChats() {
    return fireStore
        .collection(chatCollection)
        .where('users_id', arrayContains: auth.currentUser!.uid)
        .snapshots();
  }
}
