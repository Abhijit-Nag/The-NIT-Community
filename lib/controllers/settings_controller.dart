import 'dart:convert';
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

class SettingsController extends GetxController{

  var profileImagePath= "".obs;
  var profileImageLink ="";

  var feedbackController = TextEditingController();
  var loading = false.obs;

  var verificationKeyController = TextEditingController();
  var bioController = TextEditingController();

  changeImage({required context, required method})async{
    try{
      var source = method == "gallery" ? ImageSource.gallery : ImageSource.camera;
      final img =await ImagePicker().pickImage(source: source);
      if(img == null) return;
      profileImagePath.value= img.path;
    }on PlatformException catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImage({required context})async{
    try {
      var filename = basename(profileImagePath.value);
      var destination = 'images/${auth.currentUser!.uid}/$filename';
      Reference ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(File(profileImagePath.value));
      profileImageLink = await ref.getDownloadURL();
      await fireStore.collection(userCollection).doc(auth.currentUser!.uid).set(
          {
            "user_profile_photo": profileImageLink
          },
          SetOptions(merge: true));
      await auth.currentUser!.updatePhotoURL(profileImageLink);

      var userDataSnapshot = await fireStore.collection(userCollection).doc(auth.currentUser!.uid).get();
      if(userDataSnapshot.exists){
        var userData= userDataSnapshot.data();

        //updating the photo of the user in database which are already in friendList of other users
        for(int i=0;i<userData!['friends'].length;i++){
          var friendDataSnapshot=await fireStore.collection(userCollection).doc(userData!['friends'][i]['userID']).get();
          if(friendDataSnapshot.exists){
            var friendData= friendDataSnapshot.data();
            List<dynamic> friendsOfFriend= friendData!['friends'];
            int index=-1;
            index = friendsOfFriend.indexWhere((element) => element['userID']== auth.currentUser!.uid);
            if(index !=-1) {
              friendsOfFriend[index]['userPhoto'] = profileImageLink;
              print('friends : $friendsOfFriend');
              await fireStore
                  .collection(userCollection)
                  .doc(userData!['friends'][i]['userID'])
                  .update({"friends" : friendsOfFriend},);
            }
          }
        }

        //updating the photo of the user in database which are already in friend-request of other users

        // for(int i=0;i<userData!['friend_requests'].length;i++){
        //   var friendDataSnapshot= await fireStore.collection(userCollection).doc(userData!['friend_requests'][i]['userID']).get();
        //   var friendData= friendDataSnapshot.data();
        //   List<dynamic> friendRequests= friendData!['friend_request_sent'];
        //   int index=-1;
        //   index = friendRequests.indexWhere((element) => element['userID']== auth.currentUser!.uid);
        //   print('friendsrequests : $index');
        //   if(index !=-1){
        //     friendRequests[index]['userPhoto']= profileImageLink;
        //     await fireStore.collection(userCollection).doc(userData!['friend_request_sent'][i]['userID']).update({
        //       'friend_request_sent':friendRequests
        //     });
        //   }
        // }

        //updating the photo of the user in database which are already in friend-request-sent of other users

        // for(int i=0;i<userData!['friend_request_sent'].length;i++){
        //   var friendDataSnapshot= await fireStore.collection(userCollection).doc(userData!['friend_request_sent'][i]['userID']).get();
        //   var friendData= friendDataSnapshot.data();
        //   List<dynamic> friendRequests= friendData!['friend_requests'];
        //   int index=-1;
        //   index = friendRequests.indexWhere((element) => element['userID']== auth.currentUser!.uid);
        //   print('friends_request_sent : $index');
        //   if(index !=-1){
        //     friendRequests[index]['userPhoto']=profileImageLink;
        //     await fireStore.collection(userCollection).doc(userData!['friend_requests'][i]['userID']).update({
        //       'friend_requests':friendRequests
        //     });
        //   }
        // }

        for(int i=0;i<userData!['friend_request_sent'].length;i++){
          var friendDataReference= fireStore.collection(userCollection).doc(userData['friend_request_sent'][i]['userID']);
          var friendDataSnapshot= await friendDataReference.get();
          var friendData= friendDataSnapshot.data();
          int index=-1;
          List<dynamic> friendRequestsOfFriend= friendData!['friend_requests'];
          index = friendRequestsOfFriend.indexWhere((element) => element['userID'] == auth.currentUser!.uid);
          if(index!=-1) {
            friendRequestsOfFriend[index]['userPhoto'] = profileImageLink;

            await friendDataReference
                .update({"friend_requests": friendRequestsOfFriend});
          }
        }


        for(int i=0;i<userData!['friend_requests'].length;i++){
          var friendDataReference = fireStore.collection(userCollection).doc(userData!['friend_requests'][i]['userID']);
          var friendDataSnapshot= await friendDataReference.get();
          var friendData= friendDataSnapshot.data();
          int index=-1;
          List<dynamic> friendRequestSentOfFriend= friendData!['friend_request_sent'];
          index = friendRequestSentOfFriend.indexWhere((element) => element['userID'] == auth.currentUser!.uid);
          if(index !=-1){
            friendRequestSentOfFriend[index]['userPhoto'] = profileImageLink;
            await friendDataReference.update({
              "friend_request_sent": friendRequestSentOfFriend
            });
          }
        }
      }
      VxToast.show(context, msg: "image uploaded.");
      // profileImagePath.value= "";
    }catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }




  sendFeedBack({required text})async{
    await fireStore.collection(feedbackCollection).add({
      "userID": auth.currentUser!.uid,
      "feedback": text
    });
  }


  uploadCoverImage({required context})async{
    try{
      var filename = basename(profileImagePath.value);
      var destination = 'cover-images/${auth.currentUser!.uid}/$filename';
      Reference ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(File(profileImagePath.value));
      profileImageLink = await ref.getDownloadURL();

      await fireStore.collection(userCollection).doc(auth.currentUser!.uid).update({
        "coverPhoto": profileImageLink
      });
    }catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }


  verifyAccount({required key, required context})async{
    if(key.toString() == "#NITIAN"){
      await fireStore.collection(userCollection).doc(auth.currentUser!.uid).update({
        "verified": true
      });
      VxToast.show(context, msg: "Congratulation! You're verified user now.");
    }else{
      VxToast.show(context, msg: "Wrong key entered. You're not verified unfortunately.");
    }
  }


  updateUserBio({required bio, required context})async{
    try {
      if(bio.toString().isEmpty){
        VxToast.show(context, msg: "Please type your bio first.");
      }
      else {
        await fireStore
            .collection(userCollection)
            .doc(auth.currentUser!.uid)
            .update({"bio": bio});
        VxToast.show(context, msg: "Bio updated successfully.");
      }
    }catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

}