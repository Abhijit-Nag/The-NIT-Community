import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path/path.dart';

class PostController extends GetxController {
  var isEmpty = true.obs;
  var isTitleEmpty = true.obs;
  var title = "".obs;
  var titleController = TextEditingController();
  var descController = TextEditingController();

  var postImagePath = "".obs;
  var postImageLink = "";

  var postLoading = false.obs;

  uploadPost(
      {required userID,
      required postTitle,
      required postDesc,
      required context,
      required photo,
      required username}) async {
    try {
      if (postImagePath.value.isNotEmpty) {
        var filename = basename(postImagePath.value);
        var destination = 'post-images/${auth.currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(File(postImagePath.value));
        postImageLink = await ref.getDownloadURL();
      }

      // var post= await fireStore.collection(postCollection).add({
      //   "postTitle": postTitle,
      //   "postDesc":postDesc,
      //   "postFromUserID": userID,
      //   "postFromUserPhoto": photo.toString(),
      //   "postFromUsername": username.toString(),
      //   "likes":FieldValue.arrayUnion([]),
      //   "loved_it": FieldValue.arrayUnion([]),
      //   "comments": FieldValue.arrayUnion([]),
      //   "created_on": FieldValue.serverTimestamp(),
      //   "postImage": postImageLink,
      //   "userVerified": false
      // });
      //
      // var postID= post.id;

      var userSnapshots =
          await fireStore.collection(userCollection).doc(userID).get();
      if (userSnapshots.exists) {
        var data = userSnapshots.data();

        var post = await fireStore.collection(postCollection).add({
          "postTitle": postTitle,
          "postDesc": postDesc,
          "postFromUserID": userID,
          "postFromUserPhoto": photo.toString(),
          "postFromUsername": username.toString(),
          "likes": FieldValue.arrayUnion([]),
          "loved_it": FieldValue.arrayUnion([]),
          "comments": FieldValue.arrayUnion([]),
          "created_on": FieldValue.serverTimestamp(),
          "postImage": postImageLink,
          "userVerified": data!['verified']
        });

        var postID = post.id;

        var friends = userSnapshots.data()!['friends'];
        for (int i = 0; i < friends.length; i++) {
          if (data!['blocked_friends']
              .any((element) => element == friends[i]['userID'])) {
          } else {
            await fireStore
                .collection(userCollection)
                .doc(friends[i]['userID'])
                .collection(notificationCollections)
                .doc(postID)
                .set({
              "notificationFromUserID": auth.currentUser!.uid,
              "notificationFromUserPhoto": auth.currentUser!.photoURL ?? "",
              "notificationFromUsername": auth.currentUser!.displayName,
              "notificationMessage":
                  "${auth.currentUser!.displayName} has posted a post recently.",
              "notification_created_on": FieldValue.serverTimestamp(),
              "notification_type": "posts",
              "postImage": postImageLink,
              "notification_read": false,
              "notificationPostID": postID,
              "isRead": false
            });
          }
        }
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
      print(e.toString());
    }
  }

  likePost({required postID, required userID, required context}) async {
    try {
      await fireStore.collection(postCollection).doc(postID).set({
        "likes": FieldValue.arrayUnion([userID])
      }, SetOptions(merge: true));

      //  set notifications
      var postDocumentSnapshot =
          await fireStore.collection(postCollection).doc(postID).get();
      var postData = postDocumentSnapshot.data();
      await fireStore
          .collection(userCollection)
          .doc(postData!['postFromUserID'])
          .collection(notificationCollections)
          .add({
        "notificationFromUserID": userID,
        "notificationFromUserPhoto": auth.currentUser!.photoURL ?? "",
        "notificationFromUsername": auth.currentUser!.displayName,
        "notificationMessage":
            "${auth.currentUser!.displayName} liked your post.",
        "notification_created_on": FieldValue.serverTimestamp(),
        "notification_type": "reaction",
        "notification_read": false,
        "notificationPostID": postID,
        "isRead": false
      });
    } catch (e) {
      VxToast.show(context, msg: e.toString());
      print(e.toString());
    }
  }

  removeLikePost({required postID, required userID, required context}) async {
    try {
      await fireStore.collection(postCollection).doc(postID).set({
        "likes": FieldValue.arrayRemove([userID])
      }, SetOptions(merge: true));
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  lovePost({required postID, required userID, required context}) async {
    try {
      await fireStore.collection(postCollection).doc(postID).set({
        "loved_it": FieldValue.arrayUnion([userID])
      }, SetOptions(merge: true));

      //  set notifications
      var postDocumentSnapshot =
          await fireStore.collection(postCollection).doc(postID).get();
      var postData = postDocumentSnapshot.data();
      await fireStore
          .collection(userCollection)
          .doc(postData!['postFromUserID'])
          .collection(notificationCollections)
          .add({
        "notificationFromUserID": userID,
        "notificationFromUserPhoto": auth.currentUser!.photoURL ?? "",
        "notificationFromUsername": auth.currentUser!.displayName,
        "notificationMessage":
            "${auth.currentUser!.displayName} loved your post.",
        "notification_created_on": FieldValue.serverTimestamp(),
        "notification_type": "reaction",
        "notification_read": false,
        "notificationPostID": postID,
        "isRead": false
      });
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  removeLovePost({required postID, required userID, required context}) async {
    try {
      await fireStore.collection(postCollection).doc(postID).set({
        "loved_it": FieldValue.arrayRemove([userID])
      }, SetOptions(merge: true));
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<int?> getCommentsNumber({required postID, required context}) async {
    try {
      var commentSnapshot = await fireStore
          .collection(postCollection)
          .doc(postID)
          .collection(commentsCollection)
          .get();
      print(commentSnapshot.docs.length);
      return (commentSnapshot.docs.length);
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  pickPostImage({required method, required context}) async {
    try {
      var source =
          method == "gallery" ? ImageSource.gallery : ImageSource.camera;
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      postImagePath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  deletePost({required postID}) async {
    await fireStore.collection(postCollection).doc(postID).delete();
  }
}
