import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/comment_screen/comment_screen.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:the_nit_community/views/search_screen/search_screen.dart';
import 'package:the_nit_community/widgets/post_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class PostScreen extends StatelessWidget {
  String postID;
  PostScreen({Key? key, required this.postID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: FirebaseServices.getPost(postID: postID),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              var data = snapshot.data!.data() as Map<String, dynamic>?;
              return Text(data!['postFromUsername']).centered();
            }),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SearchUserScreen());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseServices.getPost(postID: postID),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            var data = snapshot.data!.data() as Map<String, dynamic>?;
            print('this is the post image: ${data!['postImage']}');
            return SingleChildScrollView(
              child: Column(
                children: [
                  Post(
                      username: data!['postFromUsername'],
                      userPhoto: data!['postFromUserPhoto'],
                      postImage: data!['postImage'],
                      postTitle: data!['postTitle'],
                      postDesc: data!['postDesc'],
                      verified: data!['userVerified'],
                      time: data!['created_on'].toDate(),
                      postID: postID,
                      userID: auth.currentUser!.uid,
                      likes: data!['likes'],
                      comments: data!['comments'],
                      loved_it: data!['loved_it']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Comments',
                            style: GoogleFonts.openSans(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined)
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => CommentScreen(postID: postID));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.comment,
                                color: Colors.blue,
                              ),
                              5.widthBox,
                              Text(
                                'Add Comment',
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).marginSymmetric(horizontal: 15, vertical: 8.0),
                  StreamBuilder(
                    stream: FirebaseServices.getAllComments(postID: postID),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.hasError.toString());
                      }
                      var data = snapshot.data!.docs;
                      if (data.isEmpty) {
                        return Stack(children: [
                          Image.network(
                              'https://img.freepik.com/premium-vector/open-empty-brown-packaging-box_287084-300.jpg'),
                          Positioned(
                            top: 350,
                            left: MediaQuery.of(context).size.width * 0.23,
                            child: Column(
                              children: [
                                Text(
                                  'Empty Comment Box!',
                                  style: GoogleFonts.firaSans(
                                      color: Colors.orange.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                10.heightBox,
                                Text(
                                  'Be first one to comment',
                                  style: GoogleFonts.firaSans(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        ]);
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var comment =
                                data[index].data() as Map<String, dynamic>;
                            if (comment != null &&
                                comment['commented_on'] != null) {
                              return Row(
                                children: [
                                  8.widthBox,
                                  comment['commenterPhoto'].toString().isEmpty
                                      ? const CircleAvatar(
                                          child: Icon(Icons.person),
                                        ).onTap(() {
                                          Get.to(() => FriendProfileScreen(
                                                userPhoto: "",
                                                username: "username",
                                                userID: "userID",
                                              ));
                                        })
                                      : Image.network(
                                          comment['commenterPhoto'].toString(),
                                          width: 35,
                                        ).onTap(() {
                                          Get.to(() => FriendProfileScreen(
                                              username: "username",
                                              userPhoto: "userPhoto",
                                              userID: "userID"));
                                        }),
                                  8.widthBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 250),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(comment['commenterUsername']),
                                              Text(
                                                comment['commenterUsername'],
                                                style: GoogleFonts.firaSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ).onTap(() {
                                                Get.to(
                                                    () => FriendProfileScreen(
                                                          userPhoto: "",
                                                          username: "username",
                                                          userID: "userID",
                                                        ));
                                              }),
                                              Text(
                                                  comment['comment'].toString(),
                                                  style: GoogleFonts.firaSans(
                                                      fontSize: 12.8))
                                            ],
                                          ),
                                        ),
                                      ),
                                      3.heightBox,
                                      Text(
                                        '${intl.DateFormat("h:mma").format(comment!['commented_on'].toDate())}  ${intl.DateFormat("dMMMMy").format(comment!['commented_on'].toDate())}',
                                        style: GoogleFonts.firaSans(
                                            fontSize: 12,
                                            color: Colors.black87
                                                .withOpacity(0.75)),
                                      )
                                    ],
                                  ),
                                ],
                              ).marginSymmetric(vertical: 8.0);
                            } else {
                              return const Text('Publishing..');
                            }
                          });
                    },
                  )
                  // Row(children: [
                  //   Text('Comments'),
                  //   Icon(Icons.keyboard_arrow_down_sharp),
                  //   CommentScreen(postID: postID)
                  // ],)
                ],
              ),
            );
          }),
    );
  }
}
