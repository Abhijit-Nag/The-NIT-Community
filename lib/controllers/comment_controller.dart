import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';

class CommentsController extends GetxController {
  var commentTextController = TextEditingController();
  uploadComment(
      {required commentText,
      required postID,
      required commenterID,
      required commenterPhoto}) async {
    await fireStore
        .collection(postCollection)
        .doc(postID)
        .collection(commentsCollection)
        .add({
      "comment": commentText,
      "commenterID": commenterID,
      "commenterPhoto": commenterPhoto ?? "",
      "commented_on": FieldValue.serverTimestamp(),
      "commenterUsername": auth.currentUser!.displayName ?? ""
    });
    var comment = {
      "comment": commentText,
      "commenterID": commenterID,
      "commenterPhoto": commenterPhoto ?? "",
      "commented_on": DateTime.now(),
      "commenterUsername": auth.currentUser!.displayName ?? ""
    };
    await fireStore.collection(postCollection).doc(postID).set({
      "comments": FieldValue.arrayUnion([comment])
    }, SetOptions(merge: true));

    //  set notifications

    var postDocumentSnapshot =
        await fireStore.collection(postCollection).doc(postID).get();
    var postData = postDocumentSnapshot.data();
    var message = trimString(commentTextController.text);
    message =
        "${auth.currentUser!.displayName} commented in your post.\n $message";
    await fireStore
        .collection(userCollection)
        .doc(postData!['postFromUserID'])
        .collection(notificationCollections)
        .add({
      "notificationFromUserID": auth.currentUser!.uid,
      "notificationFromUserPhoto": auth.currentUser!.photoURL ?? "",
      "notificationFromUsername": auth.currentUser!.displayName,
      "notificationMessage": message,
      "notification_created_on": FieldValue.serverTimestamp(),
      "notification_type": "reaction",
      "notification_read": false,
      "notificationPostID": postID
    });

    commentTextController.text = "";
  }

  String trimString(String message) {
    if (message.length > 25) {
      return "${message.substring(0, 20)}...";
    } else {
      return message;
    }
  }
}
