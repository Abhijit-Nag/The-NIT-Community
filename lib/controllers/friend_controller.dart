import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendController extends GetxController {
  // var loading= false.obs;

  acceptFriendRequest({required Map<String, dynamic> friendData}) async {
    var friends = {
      "username": friendData['username'],
      "userID": friendData['userID'],
      "email": friendData['email'],
      "userPhoto": friendData['userPhoto'],
      "friends_became_on": DateTime.timestamp()
    };

    var userDataSnapshot = await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .get();

    List<dynamic> modifiedFriendRequests = userDataSnapshot['friend_requests'];
    modifiedFriendRequests
        .removeWhere((element) => element['userID'] == friendData['userID']);

    await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      "friends": FieldValue.arrayUnion([friends]),
      "friend_requests": modifiedFriendRequests
    });
    // await fireStore.collection(userCollection).doc(auth.currentUser!.uid).set({
    //   "friends": FieldValue.arrayUnion([friends]),
    //   "friend_requests": FieldValue.arrayRemove([friendData]),
    // }, SetOptions(merge: true));

    var friendID = friendData['userID'];

    var userSnapshot =
        await fireStore.collection(userCollection).doc(friendID).get();

    if (userSnapshot.exists) {
      var friendToBeAdded = {
        "username": auth.currentUser!.displayName ?? "",
        "userID": auth.currentUser!.uid,
        "email": auth.currentUser!.email,
        "userPhoto": auth.currentUser!.photoURL ?? "",
        "friends_became_on": DateTime.timestamp()
      };

      var friendRequestSent =
          List.from(userSnapshot.data()?['friend_request_sent'] ?? []);
      friendRequestSent
          .removeWhere((element) => element['userID'] == auth.currentUser!.uid);
      await fireStore.collection(userCollection).doc(friendID).update({
        "friend_request_sent": friendRequestSent,
        "friends": FieldValue.arrayUnion([friendToBeAdded]),
      });
    }
  }

  deleteFriendRequest({required friendData}) async {
    var toBeRemoved = {
      "email": friendData['email'],
      "username": friendData['username'],
      "userID": friendData['userID'],
      "userPhoto": friendData['userPhoto']
    };
    await fireStore.collection(userCollection).doc(auth.currentUser!.uid).set({
      "friend_requests": FieldValue.arrayRemove([toBeRemoved])
    }, SetOptions(merge: true));

    var removedObject = {
      "email": auth.currentUser!.email,
      "photoURL": auth.currentUser!.photoURL ?? "",
      "userID": auth.currentUser!.uid,
      "username": auth.currentUser!.displayName
    };
    await fireStore.collection(userCollection).doc(friendData['userID']).set({
      "friend_request_sent": FieldValue.arrayRemove([removedObject])
    }, SetOptions(merge: true));
  }

  sendFriendRequest({required userData, required sendUserID}) async {
    var toBeSaved = {
      "username": userData['username'],
      "userID": sendUserID,
      "email": userData['email'],
      "photoURL": userData['user_profile_photo'] ?? "",
      "created_on": DateTime.now()
    };
    await fireStore.collection(userCollection).doc(auth.currentUser!.uid).set({
      "friend_request_sent": FieldValue.arrayUnion([toBeSaved])
    }, SetOptions(merge: true));
    var object = {
      "userID": auth.currentUser!.uid,
      "email": auth.currentUser!.email,
      "userPhoto": auth.currentUser!.photoURL ?? "",
      "username": auth.currentUser!.displayName ?? "",
      "created_on": DateTime.now()
    };
    await fireStore.collection(userCollection).doc(sendUserID).update({
      "friend_requests": FieldValue.arrayUnion([object])
    });

    var message =
        "${auth.currentUser!.displayName} has sent you friend request.";

    await fireStore
        .collection(userCollection)
        .doc(sendUserID)
        .collection(notificationCollections)
        .doc(auth.currentUser!.uid)
        .set({
      "notificationFromUsername": auth.currentUser!.displayName,
      "notificationFromUserID": auth.currentUser!.uid,
      "notification_created_on": FieldValue.serverTimestamp(),
      "notificationMessage": message,
      "notificationFromUserPhoto": auth.currentUser!.photoURL ?? "",
      "notification_type": "friend_requests",
      "notification_read": false
    });
  }

  cancelFriendRequest({required userData, required sendUserID}) async {
    var toBeSaved = {
      "username": userData['username'],
      "userID": sendUserID,
      "email": userData['email'],
      "photoURL": userData['user_profile_photo'] ?? ""
    };
    var myUserDataSnapshot = await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .get();
    var myUserData = myUserDataSnapshot.data();
    List<dynamic> myFriendRequestSent = myUserData!['friend_request_sent'];
    myFriendRequestSent
        .removeWhere((element) => element['userID'] == sendUserID);
    // await fireStore.collection(userCollection).doc(auth.currentUser!.uid).set({
    //   "friend_request_sent": FieldValue.arrayRemove([toBeSaved])
    // }, SetOptions(merge: true));

    await fireStore.collection(userCollection).doc(auth.currentUser!.uid).set(
        {"friend_request_sent": myFriendRequestSent}, SetOptions(merge: true));

    var object = {
      "userID": auth.currentUser!.uid,
      "email": auth.currentUser!.email,
      "userPhoto": auth.currentUser!.photoURL ?? "",
      "username": auth.currentUser!.displayName ?? ""
    };

    var friendUserDataSnapshot =
        await fireStore.collection(userCollection).doc(sendUserID).get();
    if (friendUserDataSnapshot.exists) {
      var friendUserData = friendUserDataSnapshot.data();
      List<dynamic> friendRequests = friendUserData!['friend_requests'];
      friendRequests
          .removeWhere((element) => element['userID'] == auth.currentUser!.uid);
      await fireStore
          .collection(userCollection)
          .doc(sendUserID)
          .set({"friend_requests": friendRequests}, SetOptions(merge: true));

      await fireStore
          .collection(userCollection)
          .doc(sendUserID)
          .collection(notificationCollections)
          .doc(auth.currentUser!.uid)
          .delete();
    }
    // await fireStore.collection(userCollection).doc(sendUserID).set({
    //   "friend_requests": FieldValue.arrayRemove([object])
    // }, SetOptions(merge: true));

    // await fireStore
    //     .collection(userCollection)
    //     .doc(sendUserID)
    //     .collection(notificationCollections)
    //     .doc(auth.currentUser!.uid)
    //     .delete();
  }

  Future<DocumentSnapshot> getProfileDetails() {
    return fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .get();
  }

  // getProfile(){
  //   var data;
  //   getData()async{
  //     data= await fireStore.collection(userCollection).doc(auth.currentUser!.uid).get();
  //   }
  //   print('data from controller : $data');
  //   data = data as Map<String, dynamic>?;
  //   return data;
  // }

  updateAuthProfileImage() async {
    // await auth.currentUser!.updatePhotoURL("");
    print('username : ${auth.currentUser!.displayName}');
    // await auth.currentUser!.updateDisplayName("user13");
    print('username : ${auth.currentUser!.displayName}');
    print('photo updated.');
    print(auth.currentUser!.photoURL);
  }

  unFriend({required friendID}) async {
    var friendSnapshot =
        await fireStore.collection(userCollection).doc(friendID).get();
    if (friendSnapshot.exists) {
      List<dynamic> friends = List.from(friendSnapshot.data()?['friends']);
      // friends= friends.filter((element) => element['userID']== auth.currentUser!.uid);
      friends
          .removeWhere((element) => element['userID'] == auth.currentUser!.uid);
      print('friend to be removed in the friendController : $friends');
      print('from the other user side : $friends');
      await fireStore
          .collection(userCollection)
          .doc(friendID)
          .set({"friends": friends}, SetOptions(merge: true));
    }

    var userSnapshot = await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .get();
    if (userSnapshot.exists) {
      List<dynamic> friends = List.from(userSnapshot.data()?['friends']);
      // friends= friends.filter((element) => element['userID']== friendID);
      friends.removeWhere((element) => element['userID'] == friendID);
      print('friend to be removed in the friendController : $friends');
      await fireStore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .set({"friends": friends}, SetOptions(merge: true));
    }
  }

  blockFriend({required friendID, required context}) async {
    try {
      await fireStore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .set({
        "blocked_friends": FieldValue.arrayUnion([friendID])
      }, SetOptions(merge: true));
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  unBlockFriend({required friendID, required context}) async {
    try {
      await fireStore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .set({
        "blocked_friends": FieldValue.arrayRemove([friendID])
      }, SetOptions(merge: true));
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  followUser({required userID, required username, required userPhoto}) async {
    var toBeFollowed = {
      "userID": auth.currentUser!.uid,
      "username": auth.currentUser!.displayName,
      "userPhoto": auth.currentUser!.photoURL ?? "",
      "created_on": DateTime.now()
    };
    await fireStore.collection(userCollection).doc(userID).update({
      "followers": FieldValue.arrayUnion([toBeFollowed])
    });

    var toBeAdded = {
      "userID": userID,
      "username": username,
      "userPhoto": userPhoto ?? "",
      "created_on": DateTime.now()
    };

    await fireStore
        .collection(userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      "followings": FieldValue.arrayUnion([toBeAdded])
    });

  //  set notifications for those user whom user is following

    var message="${auth.currentUser!.displayName} started following you.";

    await fireStore.collection(userCollection).doc(userID).collection(notificationCollections).add({
      "notificationFromUsername": auth.currentUser!.displayName,
      "notificationFromUserID": auth.currentUser!.uid,
      "notification_created_on": FieldValue.serverTimestamp(),
      "notificationMessage": message,
      "notificationFromUserPhoto": auth.currentUser!.photoURL ?? "",
      "notification_type": "follow",
      "notification_read": false
    });
  }

  unFollowUser({required userID}) async {
    var dataSnapshot =
        await fireStore.collection(userCollection).doc(userID).get();
    if (dataSnapshot.exists) {
      List<dynamic>? followers = dataSnapshot['followers'];
      followers?.removeWhere(
          (element) => element['userID'] == auth.currentUser!.uid);

      await fireStore
          .collection(userCollection)
          .doc(userID)
          .update({"followers": followers});

      var myUserDataSnapshot = await fireStore
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .get();
      if (myUserDataSnapshot.exists) {
        List<dynamic>? followings = myUserDataSnapshot['followings'];
        followings?.removeWhere((element) => element['userID'] == userID);

        await fireStore
            .collection(userCollection)
            .doc(auth.currentUser!.uid)
            .update({"followings": followings});
      }
    }
  }
}
