import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_nit_community/constants/firebase_constants.dart';
import 'package:the_nit_community/controllers/comment_controller.dart';
import 'package:the_nit_community/services/firestore_services.dart';
import 'package:the_nit_community/views/friend_profile_screen/friend_profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart' as intl;

class CommentScreen extends StatelessWidget {
  String? postID;
  CommentScreen({Key? key, required this.postID}) : super(key: key);
  var controller = Get.put(CommentsController());

  final commentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.arrow_back_ios_new_outlined).onTap(() {
          Get.back();
        }),
        title: Text(
          'Comment page',
          style: GoogleFonts.firaSans(),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder(
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
                      // shrinkWrap: true,
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
                                            userPhoto:
                                                comment['commenterPhoto'],
                                            username:
                                                comment['commenterUsername'],
                                            userID: comment['commenterID'],
                                          ));
                                    })
                                  : Image.network(
                                      comment['commenterPhoto'].toString(),
                                      width: 35,
                                    ).onTap(() {
                                      Get.to(() => FriendProfileScreen(
                                          username:
                                              comment['commenterUsername'],
                                          userPhoto: comment['commenterPhoto'],
                                          userID: comment['commenterID']));
                                    }),
                              8.widthBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 250),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
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
                                            Get.to(() => FriendProfileScreen(
                                                  userPhoto:
                                                      comment['commenterPhoto'],
                                                  username: comment[
                                                      'commenterUsername'],
                                                  userID:
                                                      comment['commenterID'],
                                                ));
                                          }),
                                          Text(comment['comment'].toString(),
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
                                        color:
                                            Colors.black87.withOpacity(0.75)),
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
              ),
            ),
            TextFormField(
              controller: controller.commentTextController,
              maxLines: 3,
              focusNode: commentFocusNode,
              decoration: InputDecoration(
                  hintText: "Type your comment",
                  prefixIcon: auth.currentUser!.photoURL != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              auth.currentUser!.photoURL.toString()),
                        ).marginOnly(left: 8.0, right: 8.0)
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ).marginOnly(left: 8.0, right: 8.0),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        commentFocusNode.unfocus();
                        await controller.uploadComment(
                            commentText: controller.commentTextController.text,
                            postID: postID,
                            commenterID: auth.currentUser!.uid,
                            commenterPhoto: auth.currentUser!.photoURL);
                        VxToast.show(context, msg: "Comment posted.");
                      },
                      icon: const Icon(Icons.send)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: const BorderSide(color: Colors.grey))),
            )
          ],
        ),
      ),
    );
  }
}
