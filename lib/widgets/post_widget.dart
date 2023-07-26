import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/post_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/comment_screen/comment_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/post_screen/post_screen.dart';
import 'package:the_nit_community/widgets/custom_loader.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class Post extends StatelessWidget {
  String username, userPhoto, postTitle, postDesc, postID, userID, postImage;
  bool verified;
  DateTime time;
  List<dynamic> likes, comments, loved_it;
  Post(
      {Key? key,
      required this.username,
      required this.postImage,
      required this.verified,
      required this.userPhoto,
      required this.postTitle,
      required this.postDesc,
      required this.time,
      required this.postID,
      required this.userID,
      required this.likes,
      required this.comments,
      required this.loved_it})
      : super(key: key);

  var controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseServices.getFriendDetails(userID: userID),
        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
      if(!snapshot.hasData){
        return Center(child: customLoader(),);
      }
      if(snapshot.hasError){
        return Center(child: Text(snapshot.error.toString()),);
      }

      var postUserData= snapshot.data!.data() as Map<String, dynamic>?;
      return Container(
        width: MediaQuery.of(context).size.width * 1,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        // height: 250,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: userPhoto.toString().isEmpty
                  ? CircleAvatar(
                child: Icon(Icons.person),
              ).onTap(() {
                Get.to(() => FriendProfileScreen(
                  userPhoto: userPhoto,
                  username: username,
                  userID: userID,
                ));
              })
                  : CircleAvatar(
                backgroundImage: NetworkImage(userPhoto),
                radius: 25,
              ).onTap(() {
                Get.to(() => FriendProfileScreen(
                  userPhoto: userPhoto,
                  username: username,
                  userID: userID,
                ));
              }),
              title: Row(
                children: [
                  Text(
                    username,
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ).onTap(() {
                    Get.to(() => FriendProfileScreen(
                      userPhoto: userPhoto,
                      username: username,
                      userID: userID,
                    ));
                  }),
                  postUserData!['verified']
                      ? const Icon(
                    Icons.verified,
                    color: Colors.blue,
                  ).marginOnly(left: 8.0)
                      : Container()
                ],
              ),
              subtitle: Text(
                  'Published on ${intl.DateFormat("h:mma").format(time)} , ${intl.DateFormat("dMMMMy").format(time)}'),
            ),
            InkWell(
              onTap: () {
                Get.to(() => PostScreen(
                  postID: postID,
                ));
              },
              child: Container(
                // height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(postTitle),
                    15.heightBox,
                    Text(postDesc),
                    10.heightBox,
                    postImage.isNotEmpty
                        ? Image.network(
                      postImage,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                        : 80.heightBox
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 0.5,
            ),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(3.0),
                          border: Border.all(color: Colors.blue, width: 1.8)),
                      child: Text(
                        likes.length.toString(),
                        style: GoogleFonts.firaSans(color: Colors.white),
                      ),
                    ),
                    5.widthBox,
                    Icon(
                      likes.contains(auth.currentUser!.uid)
                          ? Icons.thumb_up
                          : Icons.thumb_up_off_alt_outlined,
                      color: Colors.blue,
                    ),
                    5.widthBox,
                    Text(
                      'Like',
                      style: GoogleFonts.firaSans(
                          fontSize: 12, color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                ).onTap(() async {
                  if (likes.contains(auth.currentUser!.uid)) {
                    await controller.removeLikePost(
                        postID: postID,
                        userID: auth.currentUser!.uid,
                        context: context);
                    VxToast.show(context, msg: "Unliked post.");
                  } else {
                    await controller.likePost(
                        postID: postID,
                        userID: auth.currentUser!.uid,
                        context: context);
                    if (loved_it.contains(auth.currentUser!.uid)) {
                      await controller.removeLovePost(
                          postID: postID,
                          userID: auth.currentUser!.uid,
                          context: context);
                    }
                    VxToast.show(context, msg: "Liked post.");
                  }
                }),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(3.0),
                          border:
                          Border.all(color: Colors.pinkAccent, width: 1.8)),
                      child: Text(
                        comments.length.toString(),
                        style: GoogleFonts.firaSans(color: Colors.white),
                      ),
                    ),
                    5.widthBox,
                    Icon(Icons.comment_rounded),
                    5.widthBox,
                    Text('Comment',
                        style: GoogleFonts.firaSans(
                            fontSize: 12, color: Colors.black.withOpacity(0.5)))
                  ],
                ).onTap(() {
                  Get.to(() => CommentScreen(
                    postID: postID.toString(),
                  ));
                }),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(3.0),
                          border:
                          Border.all(color: Colors.pinkAccent, width: 1.8)),
                      child: Text(
                        loved_it.length.toString(),
                        style: GoogleFonts.firaSans(color: Colors.white),
                      ),
                    ),
                    5.widthBox,
                    Icon(
                      loved_it.contains(auth.currentUser!.uid)
                          ? Icons.favorite
                          : Icons.favorite_outline_rounded,
                      color: Colors.pinkAccent,
                    ),
                    5.widthBox,
                    Text('Loved it',
                        style: GoogleFonts.firaSans(
                            fontSize: 12, color: Colors.black.withOpacity(0.5)))
                  ],
                ).onTap(() async {
                  if (loved_it.contains(auth.currentUser!.uid)) {
                    await controller.removeLovePost(
                        postID: postID,
                        userID: auth.currentUser!.uid,
                        context: context);
                    VxToast.show(context, msg: "Removed love post.");
                  } else {
                    await controller.lovePost(
                        postID: postID,
                        userID: auth.currentUser!.uid,
                        context: context);
                    if (likes.contains(auth.currentUser!.uid)) {
                      await controller.removeLikePost(
                          postID: postID,
                          userID: auth.currentUser!.uid,
                          context: context);
                    }
                    VxToast.show(context, msg: "Loved post.");
                  }
                })
              ],
            ),
            // const Divider(thickness: 0.5,)
            15.heightBox
          ],
        ),
      );
    });
  }
}
